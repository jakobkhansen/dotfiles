require("agentic").setup({
    -- Any ACP-compatible provider works. Built-in: "claude-agent-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp" | "copilot-acp" | "auggie-acp" | "mistral-vibe-acp" | "cline-acp" | "goose-acp" | "kiro-acp" | "pi-acp"
    provider = "copilot-acp", -- setting the name here is all you need to get started
    keymaps = {
        widget = {
            change_mode = "<C-m>",
        },
        prompt = {
            submit = {
                "<CR>",
                {
                    "<CR>",
                    mode = { "i", "n", "v" },
                },
            },
        }
    },
    diff_preview = {
        enabled = true,
        layout = "inline", -- "split" or "inline"
        center_on_navigate_hunks = true,
    },
    settings = {
        cursor_on_submit = "editor",
    },
    hooks = {
        on_request_permission = function(data)
            local tc = data.request.toolCall
            if tc.kind == "edit" then
                return nil
            end
            local title = (tc.title or ""):lower()
            if title:find("%f[%w]git%f[%W]") then
                local read_only_git = {
                    status = true, diff = true, log = true, show = true,
                    blame = true, ["ls-files"] = true, ["ls-tree"] = true,
                    ["rev-parse"] = true, ["rev-list"] = true,
                    describe = true, shortlog = true, reflog = true,
                    grep = true, whatchanged = true, ["cat-file"] = true,
                }
                local rest = title:match("%f[%w]git%s+(.+)$") or ""
                while #rest > 0 do
                    local word, tail = rest:match("^(%S+)%s*(.*)$")
                    if not word then break end
                    if word == "-c" or word == "-C"
                        or word == "--git-dir" or word == "--work-tree"
                        or word == "--namespace" then
                        rest = tail:match("^%S+%s*(.*)$") or ""
                    elseif word:sub(1, 1) == "-" then
                        rest = tail
                    else
                        return read_only_git[word] and "allow_once" or nil
                    end
                end
                return nil
            end
            return "allow_once"
        end,
    },
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "AgenticChat",
    callback = function(ev)
        vim.treesitter.start(ev.buf, "markdown")
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "AgenticInput",
    callback = function()
        vim.opt.tw = 0
    end,
})
