--- copilot_cli.lua — talk to a running GitHub Copilot CLI TUI from Neovim.
---
--- Copilot CLI exposes no IPC we can use (ACP only), so this injects synthetic
--- keystrokes into the TUI's Windows console input buffer:
---   FreeConsole() -> AttachConsole(pid) -> WriteConsoleInputW(CONIN$)
--- Node's stdin (libuv) reads that buffer via ReadConsoleInputW, so the records
--- are indistinguishable from real typing.
---
--- The FreeConsole() call means this can never run in-process: it would tear
--- down Neovim's own console. So we shell out to a helper, embedded below and
--- materialised into stdpath("cache") on first use.
---
--- Windows-only by construction. On Linux the equivalent (TIOCSTI) is disabled
--- since kernel 6.2, and writing to /proc/<pid>/fd/0 only echoes to the
--- terminal without entering the process's input queue.

local M = {}

local SESSION_DIR = vim.fs.normalize(vim.fn.expand("~/.copilot/session-state"))

---@class CopilotInstance
---@field pid integer
---@field session string
---@field cwd string
---@field repository string?
---@field branch string?
---@field mtime integer

--------------------------------------------------------------------------------
-- Helper script (PowerShell + P/Invoke)
--------------------------------------------------------------------------------

local HELPER_SOURCE = [==[
param(
  [Parameter(Mandatory)][int]$TargetPid,
  [Parameter(Mandatory)][string]$TextFile,
  [switch]$Enter,
  [switch]$BracketedPaste,
  [int]$EnterDelayMs = 120
)

Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public static class CopilotConsoleInject {
    [StructLayout(LayoutKind.Sequential)]
    public struct KEY_EVENT_RECORD {
        public int    bKeyDown;
        public ushort wRepeatCount;
        public ushort wVirtualKeyCode;
        public ushort wVirtualScanCode;
        public ushort UnicodeChar;
        public uint   dwControlKeyState;
    }

    [StructLayout(LayoutKind.Explicit)]
    public struct INPUT_RECORD {
        [FieldOffset(0)] public ushort EventType;
        [FieldOffset(4)] public KEY_EVENT_RECORD KeyEvent;
    }

    [DllImport("kernel32.dll", SetLastError=true)] public static extern bool FreeConsole();
    [DllImport("kernel32.dll", SetLastError=true)] public static extern bool AttachConsole(uint dwProcessId);
    [DllImport("kernel32.dll", SetLastError=true, CharSet=CharSet.Unicode)]
    public static extern IntPtr CreateFileW(string name, uint access, uint share,
        IntPtr sa, uint creation, uint flags, IntPtr template);
    [DllImport("kernel32.dll", SetLastError=true)]
    public static extern bool WriteConsoleInputW(IntPtr h, INPUT_RECORD[] buf, uint len, out uint written);
    [DllImport("kernel32.dll", SetLastError=true)] public static extern bool CloseHandle(IntPtr h);

    const ushort KEY_EVENT = 1;

    static INPUT_RECORD Rec(char ch, bool down) {
        INPUT_RECORD r = new INPUT_RECORD();
        r.EventType = KEY_EVENT;
        r.KeyEvent.bKeyDown = down ? 1 : 0;
        r.KeyEvent.wRepeatCount = 1;
        r.KeyEvent.wVirtualKeyCode = (ch == '\r') ? (ushort)0x0D : (ushort)0;
        r.KeyEvent.wVirtualScanCode = 0;
        r.KeyEvent.UnicodeChar = (ushort)ch;
        r.KeyEvent.dwControlKeyState = 0;
        return r;
    }

    static string Write(IntPtr h, string text) {
        var recs = new System.Collections.Generic.List<INPUT_RECORD>();
        foreach (char c in text) { recs.Add(Rec(c, true)); recs.Add(Rec(c, false)); }
        var arr = recs.ToArray();
        uint written;
        int i = 0;
        // Chunk to stay clear of the console input buffer's capacity.
        while (i < arr.Length) {
            int n = Math.Min(512, arr.Length - i);
            var chunk = new INPUT_RECORD[n];
            Array.Copy(arr, i, chunk, 0, n);
            if (!WriteConsoleInputW(h, chunk, (uint)n, out written))
                return "WriteConsoleInput failed: " + Marshal.GetLastWin32Error();
            i += n;
            System.Threading.Thread.Sleep(1);
        }
        return "";
    }

    /// Returns "" on success, else an error description.
    public static string Send(uint pid, string text, bool enter, int enterDelayMs) {
        FreeConsole();
        if (!AttachConsole(pid))
            return "AttachConsole(" + pid + ") failed: " + Marshal.GetLastWin32Error();

        IntPtr h = CreateFileW("CONIN$", 0x80000000 | 0x40000000, 3, IntPtr.Zero, 3, 0, IntPtr.Zero);
        if (h == new IntPtr(-1))
            return "CreateFile(CONIN$) failed: " + Marshal.GetLastWin32Error();

        try {
            string err = Write(h, text);
            if (err != "") return err;
            if (enter) {
                // Let the TUI drain the paste before submitting.
                System.Threading.Thread.Sleep(enterDelayMs);
                err = Write(h, "\r");
                if (err != "") return err;
            }
        } finally {
            CloseHandle(h);
            FreeConsole();
        }
        return "";
    }
}
'@

$payload = [System.IO.File]::ReadAllText($TextFile)
Remove-Item $TextFile -ErrorAction SilentlyContinue

# Bracketed paste makes the TUI treat the text as literal input, so a leading
# "/" or an "@" can't trigger its slash-command or file-mention popups.
if ($BracketedPaste) { $payload = "$([char]27)[200~" + $payload + "$([char]27)[201~" }

$result = [CopilotConsoleInject]::Send([uint32]$TargetPid, $payload, $Enter.IsPresent, $EnterDelayMs)
if ($result -ne "") { [Console]::Error.WriteLine($result); exit 1 }
]==]

local helper_path

local function ensure_helper()
  if helper_path and vim.uv.fs_stat(helper_path) then
    return helper_path
  end
  local dir = vim.fn.stdpath("cache")
  local path = dir .. "/copilot_cli_inject.ps1"
  local fd = io.open(path, "wb")
  if not fd then
    error("copilot_cli: cannot write helper to " .. path)
  end
  fd:write(HELPER_SOURCE)
  fd:close()
  helper_path = path
  return path
end

local powershell_exe
local function ensure_powershell()
  if powershell_exe then
    return powershell_exe
  end
  for _, exe in ipairs({ "pwsh", "powershell" }) do
    if vim.fn.executable(exe) == 1 then
      powershell_exe = exe
      return exe
    end
  end
  error("copilot_cli: neither pwsh nor powershell found on PATH")
end

--------------------------------------------------------------------------------
-- Instance discovery
--------------------------------------------------------------------------------

--- PIDs of live copilot.exe processes. The inuse.*.lock files go stale when a
--- process dies, so they must always be filtered against this.
---@return table<integer, boolean>
local function live_pids()
  local out = vim.fn.systemlist({ "tasklist", "/FI", "IMAGENAME eq copilot.exe", "/FO", "CSV", "/NH" })
  local pids = {}
  if vim.v.shell_error ~= 0 then
    return pids
  end
  for _, line in ipairs(out) do
    local pid = line:match('^"copilot%.exe","(%d+)"')
    if pid then
      pids[tonumber(pid)] = true
    end
  end
  return pids
end

---@param path string
---@return table<string, string>
local function read_workspace(path)
  local fields = {}
  local fd = io.open(path, "r")
  if not fd then
    return fields
  end
  for line in fd:lines() do
    local key, value = line:match("^(%w[%w_]*):%s*(.-)%s*$")
    if key and value ~= "" then
      fields[key] = value
    end
  end
  fd:close()
  return fields
end

--- All running Copilot CLI instances, newest session first.
---@return CopilotInstance[]
function M.instances()
  local live = live_pids()
  local found = {} ---@type table<integer, CopilotInstance>

  for _, lock in ipairs(vim.fn.glob(SESSION_DIR .. "/*/inuse.*.lock", true, true)) do
    local pid = tonumber(lock:match("inuse%.(%d+)%.lock$"))
    if pid and live[pid] then
      local dir = vim.fs.dirname(lock)
      local stat = vim.uv.fs_stat(dir)
      local mtime = stat and stat.mtime.sec or 0
      -- PIDs get recycled, so a stale lock can collide with a live one.
      -- Keep whichever session was touched most recently.
      local prev = found[pid]
      if not prev or mtime > prev.mtime then
        local ws = read_workspace(dir .. "/workspace.yaml")
        found[pid] = {
          pid = pid,
          session = vim.fs.basename(dir),
          cwd = ws.cwd or "",
          repository = ws.repository,
          branch = ws.branch,
          mtime = mtime,
        }
      end
    end
  end

  local list = vim.tbl_values(found)
  table.sort(list, function(a, b)
    return a.mtime > b.mtime
  end)
  return list
end

---@param inst CopilotInstance
---@return string
local function label(inst)
  local name = inst.repository or (inst.cwd ~= "" and vim.fs.basename(inst.cwd)) or ("pid " .. inst.pid)
  local parts = { name }
  if inst.branch then
    table.insert(parts, "(" .. inst.branch .. ")")
  end
  table.insert(parts, "· pid " .. inst.pid)
  return table.concat(parts, " ")
end

--------------------------------------------------------------------------------
-- Target selection
--------------------------------------------------------------------------------

M.config = {
  cmd = "copilot",
  --- How to open a new instance. Override for a different split, snacks.terminal, etc.
  ---@param cmd string
  open = function(cmd)
    vim.cmd("vsplit")
    vim.cmd.terminal(cmd)
  end,
  --- How long to wait for a freshly spawned CLI to register itself.
  spawn_timeout_ms = 30000,
  --- Grace period after it registers, before we start typing at it.
  settle_ms = 1500,
}

local selected_pid = nil

--- Open a new Copilot CLI and wait for it to become addressable.
---@param callback fun(inst: CopilotInstance)
local function spawn(callback)
  if vim.fn.executable(M.config.cmd) == 0 then
    vim.notify("copilot_cli: '" .. M.config.cmd .. "' not found on PATH", vim.log.levels.ERROR)
    return
  end

  local before = {}
  for _, inst in ipairs(M.instances()) do
    before[inst.pid] = true
  end

  -- Keep the user where they were; the terminal is a side-car, not the focus.
  local prev_win = vim.api.nvim_get_current_win()
  local ok, err = pcall(M.config.open, M.config.cmd)
  if not ok then
    vim.notify("copilot_cli: failed to open Copilot CLI: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  if vim.api.nvim_win_is_valid(prev_win) then
    vim.api.nvim_set_current_win(prev_win)
  end

  vim.notify("copilot_cli: starting Copilot CLI…")

  -- The session lock only appears once the CLI is well into startup, so poll
  -- for a PID we hadn't seen before rather than guessing a fixed delay.
  local start = vim.uv.now()
  local timer = vim.uv.new_timer()
  timer:start(
    500,
    500,
    vim.schedule_wrap(function()
      if timer:is_closing() then
        return
      end

      local found
      for _, inst in ipairs(M.instances()) do
        if not before[inst.pid] then
          found = inst
          break
        end
      end

      if found then
        timer:stop()
        timer:close()
        selected_pid = found.pid
        -- Registering the lock precedes accepting input; give the TUI a beat.
        vim.defer_fn(function()
          callback(found)
        end, M.config.settle_ms)
      elseif vim.uv.now() - start > M.config.spawn_timeout_ms then
        timer:stop()
        timer:close()
        vim.notify("copilot_cli: timed out waiting for Copilot CLI to start", vim.log.levels.ERROR)
      end
    end)
  )
end

---@param callback fun(inst: CopilotInstance)
---@param opts? { pick?: boolean, new?: boolean }
local function with_target(callback, opts)
  opts = opts or {}

  -- Always a fresh session, regardless of what's already running.
  if opts.new then
    return spawn(callback)
  end

  local list = M.instances()

  if #list == 0 then
    if opts.pick then
      vim.notify("copilot_cli: no running Copilot CLI instance found", vim.log.levels.ERROR)
      return
    end
    return spawn(callback)
  end

  if not opts.pick then
    if selected_pid then
      for _, inst in ipairs(list) do
        if inst.pid == selected_pid then
          return callback(inst)
        end
      end
      -- Previously selected instance is gone; fall through and re-pick.
      selected_pid = nil
    end
    if #list == 1 then
      selected_pid = list[1].pid
      return callback(list[1])
    end
  end

  vim.ui.select(list, {
    prompt = "Copilot CLI instance:",
    format_item = label,
  }, function(choice)
    if not choice then
      return
    end
    selected_pid = choice.pid
    callback(choice)
  end)
end

--- Pick which instance to target from now on.
function M.switch()
  with_target(function(inst)
    vim.notify("copilot_cli: targeting " .. label(inst))
  end, { pick = true })
end

--- Open a new Copilot CLI and target it.
function M.open()
  spawn(function(inst)
    vim.notify("copilot_cli: targeting " .. label(inst))
  end)
end

--------------------------------------------------------------------------------
-- Context placeholders
--------------------------------------------------------------------------------

--- Format a buffer location the way Copilot can resolve it: a path relative to
--- the instance's cwd, optionally suffixed with :L<line>:C<col>-L<line>:C<col>.
---@return string?
local function format_location(buf, from, to, rel)
  local path = vim.api.nvim_buf_get_name(buf)
  if path == "" then
    return nil
  end
  path = vim.fs.normalize(vim.fn.fnamemodify(path, ":p"))

  if rel and rel ~= "" then
    local prefix = vim.fs.normalize(rel):gsub("/$", "") .. "/"
    -- Windows paths are case-insensitive.
    if path:lower():sub(1, #prefix) == prefix:lower() then
      path = path:sub(#prefix + 1)
    end
  end

  if from then
    path = path .. string.format(":L%d", from[1])
    if from[2] then
      path = path .. string.format(":C%d", from[2])
    end
    if to then
      path = path .. string.format("-L%d", to[1])
      if to[2] then
        path = path .. string.format(":C%d", to[2])
      end
    end
  end
  return path
end

--- Visual selection, captured before any UI switches modes.
local function get_range()
  local mode = vim.fn.mode()
  local kind = (mode == "V" and "line") or (mode == "v" and "char") or (mode == "\22" and "block")
  if not kind then
    return nil
  end

  -- Leave visual mode so the '< '> marks are set consistently.
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "x", true)

  local buf = vim.api.nvim_get_current_buf()
  local from = vim.api.nvim_buf_get_mark(buf, "<")
  local to = vim.api.nvim_buf_get_mark(buf, ">")
  if from[1] > to[1] or (from[1] == to[1] and from[2] > to[2]) then
    from, to = to, from
  end
  return { from = from, to = to, kind = kind }
end

--- Snapshot of where the prompt was made, taken before opening any input UI.
local function make_context()
  local win = vim.api.nvim_get_current_win()
  return {
    buf = vim.api.nvim_win_get_buf(win),
    cursor = vim.api.nvim_win_get_cursor(win),
    range = get_range(),
  }
end

---@type table<string, fun(ctx: table, cwd: string): string?>
M.contexts = {
  ---Selection if any, else the cursor position.
  ["@this"] = function(ctx, cwd)
    if ctx.range then
      local from = { ctx.range.from[1] }
      local to = { ctx.range.to[1] }
      if ctx.range.kind ~= "line" then
        from[2] = ctx.range.from[2] + 1
        to[2] = ctx.range.to[2] + 1
      end
      return format_location(ctx.buf, from, to, cwd)
    end
    return format_location(ctx.buf, { ctx.cursor[1], ctx.cursor[2] + 1 }, nil, cwd)
  end,

  ---The current buffer.
  ["@buffer"] = function(ctx, cwd)
    return format_location(ctx.buf, nil, nil, cwd)
  end,

  ---All listed buffers.
  ["@buffers"] = function(_, cwd)
    local paths = {}
    for _, info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      local p = format_location(info.bufnr, nil, nil, cwd)
      if p then
        table.insert(paths, p)
      end
    end
    return #paths > 0 and table.concat(paths, ", ") or nil
  end,
}

---Replace placeholders in `prompt` with their resolved values.
local function render(prompt, ctx, cwd)
  -- Longest first so @buffers wins over @buffer.
  local keys = vim.tbl_keys(M.contexts)
  table.sort(keys, function(a, b)
    return #a > #b
  end)

  local out, i = {}, 1
  while i <= #prompt do
    local next_pos, next_key = #prompt + 1, nil
    for _, key in ipairs(keys) do
      local pos = prompt:find(key, i, true)
      if pos and pos < next_pos then
        next_pos, next_key = pos, key
      end
    end

    table.insert(out, prompt:sub(i, next_pos - 1))
    if not next_key then
      break
    end
    -- Leave the placeholder verbatim if it resolves to nothing.
    table.insert(out, M.contexts[next_key](ctx, cwd) or next_key)
    i = next_pos + #next_key
  end
  return table.concat(out)
end

--------------------------------------------------------------------------------
-- Sending
--------------------------------------------------------------------------------

---@param text string
---@param opts? { submit?: boolean, pid?: integer }
local function inject(text, opts)
  opts = opts or {}
  local payload = vim.fn.tempname()
  local fd = io.open(payload, "wb")
  if not fd then
    vim.notify("copilot_cli: cannot write payload", vim.log.levels.ERROR)
    return
  end
  fd:write(text)
  fd:close()

  local cmd = {
    ensure_powershell(),
    "-NoProfile",
    "-NonInteractive",
    "-File",
    ensure_helper(),
    "-TargetPid",
    tostring(opts.pid),
    "-TextFile",
    payload,
    "-BracketedPaste",
  }
  if opts.submit ~= false then
    table.insert(cmd, "-Enter")
  end

  local stderr = {}
  vim.fn.jobstart(cmd, {
    stderr_buffered = true,
    on_stderr = function(_, data)
      for _, line in ipairs(data or {}) do
        if line ~= "" then
          table.insert(stderr, line)
        end
      end
    end,
    on_exit = function(_, code)
      if code ~= 0 then
        vim.schedule(function()
          vim.notify(
            "copilot_cli: send failed" .. (#stderr > 0 and (": " .. table.concat(stderr, " ")) or ""),
            vim.log.levels.ERROR
          )
        end)
      end
    end,
  })
end

--- Send `text` to the target instance, expanding placeholders.
---@param text string
---@param opts? { submit?: boolean, new?: boolean }
function M.prompt(text, opts)
  opts = opts or {}
  local ctx = make_context()
  with_target(function(inst)
    local rendered = render(text, ctx, inst.cwd)
    inject(rendered, { submit = opts.submit, pid = inst.pid })
  end, { new = opts.new })
end

--- Prompt for input, then send it. Mirrors opencode.nvim's ask().
---@param prefix? string Prefilled text, e.g. "@this: "
---@param opts? { new?: boolean } `new` forces a fresh session instead of reusing one.
function M.ask(prefix, opts)
  opts = opts or {}
  local ctx = make_context()
  -- Ask before resolving a target, so cancelling can't spawn a stray terminal.
  vim.ui.input({ prompt = "Copilot: ", default = prefix or "" }, function(input)
    if not input or vim.trim(input) == "" then
      return
    end
    with_target(function(inst)
      inject(render(input, ctx, inst.cwd), { pid = inst.pid })
    end, { new = opts.new })
  end)
end

--- Like ask(), but always in a brand new session.
---@param prefix? string Prefilled text, e.g. "@this: "
function M.ask_new(prefix)
  M.ask(prefix, { new = true })
end

--------------------------------------------------------------------------------

vim.api.nvim_create_user_command("CopilotAsk", function(cmd)
  if cmd.args ~= "" then
    M.prompt(cmd.args)
  else
    M.ask("@this: ")
  end
end, { nargs = "*", range = true, desc = "Ask the running Copilot CLI" })

vim.api.nvim_create_user_command("CopilotAskNew", function(cmd)
  if cmd.args ~= "" then
    M.prompt(cmd.args, { new = true })
  else
    M.ask_new("@this: ")
  end
end, { nargs = "*", range = true, desc = "Ask a new Copilot CLI session" })

vim.api.nvim_create_user_command("CopilotSwitch", function()
  M.switch()
end, { desc = "Switch target Copilot CLI instance" })

vim.api.nvim_create_user_command("CopilotOpen", function()
  M.open()
end, { desc = "Open a new Copilot CLI instance" })

return M
