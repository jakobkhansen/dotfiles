<#
.SYNOPSIS
    Types text into the focused window - fast enough to be bound to a hotkey.

.DESCRIPTION
    Replaces the usual
        powershell "Add-Type -AssemblyName System.Windows.Forms; [...]::SendWait('a')"
    hotkey trick, which pays PowerShell start-up plus a WinForms load on every press.
    The embedded C# is compiled once into a cached windowless .exe and reused, cutting
    a keypress from ~245ms to ~90ms (of which ~40ms is process creation itself,
    the floor for any language on this machine).

    Uses SendInput with KEYEVENTF_UNICODE rather than SendKeys, so the character is
    independent of the active keyboard layout.

    Modifier handling matters here: a hotkey fires while its modifiers are still
    physically down, and a character sent then becomes WM_SYSCHAR (a menu accelerator)
    and is silently dropped - verified, it types nothing at all. The old PowerShell
    version only got away with it because it took ~1s to start, by which point the key
    was long released. This masks with Ctrl (so the bare Alt does not open the window
    menu), releases the modifiers, types, then restores them.

.PARAMETER Text
    Literal text, and/or U+00E5 / 0x00E5 escapes so a config file need not carry
    non-ASCII bytes through another program's argument parsing.

.PARAMETER WaitMods
    Milliseconds to wait for the hotkey's modifiers to be released before typing.
    Default 0: waiting costs exactly as long as you hold the key, so instead the
    modifiers are masked, released, the character typed, and the modifiers restored.
    Set a value only if an application dislikes that (verified: 6 repeats while Alt
    is held all arrive, and no modifier is left stuck).

.PARAMETER Dry
    Do everything except send the keystrokes.

.PARAMETER Build
    Force a rebuild of the cached executable, then exit.

.PARAMETER ExePath
    Print the cached executable's path and exit (use this in hotkey bindings).

.EXAMPLE
    .\send-text.ps1 U+00E5           # a-ring
.EXAMPLE
    .\send-text.ps1 U+00F8           # o-slash, no non-ASCII in the caller
.EXAMPLE
    # GlazeWM binding with no PowerShell start-up cost:
    #   shell-exec --hide-window <output of: .\send-text.ps1 -ExePath> U+00E5

.NOTES
    Measured on this machine (ARM64), process launch to exit:
      powershell + WinForms (the old binding) ... ~245ms
      .NET Framework csc build ................. ~228ms  (runs x86-emulated on ARM64)
      .NET SDK build ...........................  ~85ms
    The SDK is preferred when present for that reason; csc is the fallback so the
    script still works on a machine with no SDK installed.
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0)][string]$Text,
    [int]$WaitMods = -1,
    [switch]$Dry,
    [string]$Log,
    [switch]$Build,
    [switch]$ExePath
)

$ErrorActionPreference = 'Stop'

$CSharp = @'
// sendtext.exe - type a literal string into the focused window via SendInput with
// KEYEVENTF_UNICODE. Layout independent (unlike SendKeys), and with no PowerShell or
// WinForms to load it starts in tens of milliseconds instead of ~a second.
//
// Usage: sendtext.exe <text|U+00E5> [--wait-mods <ms>] [--dry] [--log <file>]
//
// Build: csc /nologo /target:winexe /optimize /out:sendtext.exe sendtext.cs

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;

internal static class Program
{
    const uint INPUT_KEYBOARD = 1;
    const uint KEYEVENTF_KEYUP = 0x0002;
    const uint KEYEVENTF_UNICODE = 0x0004;

    const int VK_SHIFT = 0x10, VK_CONTROL = 0x11, VK_MENU = 0x12,
              VK_LWIN = 0x5B, VK_RWIN = 0x5C;

    static Stopwatch _clock = Stopwatch.StartNew();
    static TextWriter _log;
    static bool _console;

    [STAThread]
    static int Main(string[] args)
    {
        string text = null, logPath = null;
        int waitMods = 0;   // 0 = never wait; the mask/release/restore path handles held modifiers
        bool dry = false;

        for (int i = 0; i < args.Length; i++)
        {
            string a = args[i];
            if (a.Equals("--dry", StringComparison.OrdinalIgnoreCase)) dry = true;
            else if (a.Equals("--wait-mods", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                waitMods = int.Parse(args[++i], CultureInfo.InvariantCulture);
            else if (a.Equals("--log", StringComparison.OrdinalIgnoreCase) && i + 1 < args.Length)
                logPath = args[++i];
            else if (!a.StartsWith("--")) text = text == null ? a : text + a;
        }

        try
        {
            if (logPath != null) _log = new StreamWriter(logPath, false, new UTF8Encoding(false)) { AutoFlush = true };
            if (text == null) { Say("usage: sendtext.exe <text|U+00E5> [--wait-mods ms] [--dry]"); return 64; }

            text = Decode(text);
            Say("text=\"" + text + "\" (" + Describe(text) + ")");

            // A hotkey fires while its modifiers are still physically down, and a character
            // typed then is swallowed (it becomes WM_SYSCHAR, a menu accelerator). Waiting
            // for the user to let go costs exactly as long as they hold the key, so by
            // default we do not wait and instead release/restore the modifiers below.
            // --wait-mods N restores the waiting behaviour if an app dislikes that.
            int waited = WaitForModifiers(waitMods);
            if (waited > 0) Say("waited " + waited + "ms for modifiers");

            if (dry) { Say("dry run - nothing sent"); return 0; }

            uint sent;
            if (ModifiersDown())
            {
                // Still held after the timeout (user leaning on Alt). Release the
                // modifiers around the keystroke, then restore them so the app's view
                // matches the keys the user is physically holding.
                int[] held = HeldModifiers();
                Say("modifiers still held (" + held.Length + ") - masking and releasing");
                SendVk(VK_CONTROL, false);   // mask: stops the bare Alt-tap from
                SendVk(VK_CONTROL, true);    // opening the window menu
                foreach (int vk in held) SendVk(vk, true);
                sent = SendUnicode(text);
                foreach (int vk in held) SendVk(vk, false);
            }
            else sent = SendUnicode(text);

            Say("sent " + sent + " input event(s)");
            return sent > 0 ? 0 : 1;
        }
        catch (Exception ex) { Say("FATAL " + ex.GetType().Name + ": " + ex.Message); return 99; }
        finally { if (_log != null) _log.Dispose(); }
    }

    static void Say(string msg)
    {
        string line = _clock.ElapsedMilliseconds.ToString("0000", CultureInfo.InvariantCulture) + "ms  " + msg;
        if (_log != null) _log.WriteLine(line);
        if (!_console) return;   // touching Console costs ~10ms to initialise
    }

    // Accepts literal text plus U+00E5 / 0x00E5 escapes (exactly four hex digits), or the
    // explicit U+{1F600} form, so a config file need not carry non-ASCII bytes through
    // another program's argument handling.
    static string Decode(string raw)
    {
        // hand-rolled scan; Regex costs ~15ms to initialise on first use
        StringBuilder outp = new StringBuilder(raw.Length);
        for (int i = 0; i < raw.Length; )
        {
            int start = i, hexAt = -1;
            if (raw[i] == 'U' || raw[i] == 'u') { if (i + 1 < raw.Length && raw[i + 1] == '+') hexAt = i + 2; }
            else if (raw[i] == '0' && i + 1 < raw.Length && (raw[i + 1] == 'x' || raw[i + 1] == 'X')) hexAt = i + 2;
            if (hexAt > 0)
            {
                int j = hexAt;
                // Exactly four hex digits, so a literal character that happens to be a hex
                // digit is not swallowed ("aU+00E5b" is "a", U+00E5, "b"). Use the explicit
                // brace form, U+{1F600}, for anything outside the BMP.
                if (hexAt < raw.Length && raw[hexAt] == '{')
                {
                    j = hexAt + 1;
                    while (j < raw.Length && j - hexAt <= 6 && Uri.IsHexDigit(raw[j])) j++;
                    if (j < raw.Length && raw[j] == '}' && j > hexAt + 1)
                    {
                        int cpb = int.Parse(raw.Substring(hexAt + 1, j - hexAt - 1), NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                        outp.Append(char.ConvertFromUtf32(cpb));
                        i = j + 1; continue;
                    }
                }
                else
                {
                    while (j < raw.Length && j - hexAt < 4 && Uri.IsHexDigit(raw[j])) j++;
                    if (j - hexAt == 4)
                    {
                        int cp = int.Parse(raw.Substring(hexAt, 4), NumberStyles.HexNumber, CultureInfo.InvariantCulture);
                        outp.Append(char.ConvertFromUtf32(cp));
                        i = j; continue;
                    }
                }
            }
            outp.Append(raw[start]); i = start + 1;
        }
        return outp.ToString();
    }

    static string Describe(string s)
    {
        StringBuilder sb = new StringBuilder();
        foreach (char c in s)
        {
            if (sb.Length > 0) sb.Append(' ');
            sb.Append("U+").Append(((int)c).ToString("X4", CultureInfo.InvariantCulture));
        }
        return sb.ToString();
    }

    static int WaitForModifiers(int timeoutMs)
    {
        if (timeoutMs <= 0) return 0;
        Stopwatch sw = Stopwatch.StartNew();
        while (sw.ElapsedMilliseconds < timeoutMs && ModifiersDown()) Thread.Sleep(5);
        return (int)sw.ElapsedMilliseconds;
    }

    static bool ModifiersDown()
    {
        return Down(VK_MENU) || Down(VK_CONTROL) || Down(VK_SHIFT) || Down(VK_LWIN) || Down(VK_RWIN);
    }

    static bool Down(int vk) { return (GetAsyncKeyState(vk) & 0x8000) != 0; }

    static int[] HeldModifiers()
    {
        List<int> held = new List<int>();
        foreach (int vk in new int[] { VK_MENU, VK_CONTROL, VK_SHIFT, VK_LWIN, VK_RWIN })
            if (Down(vk)) held.Add(vk);
        return held.ToArray();
    }

    static void SendVk(int vk, bool up)
    {
        INPUT i = new INPUT();
        i.type = INPUT_KEYBOARD;
        i.U.ki.wVk = (ushort)vk;
        i.U.ki.dwFlags = up ? KEYEVENTF_KEYUP : 0;
        SendInput(1, new INPUT[] { i }, Marshal.SizeOf(typeof(INPUT)));
    }

    static uint SendUnicode(string text)
    {
        List<INPUT> inputs = new List<INPUT>();
        foreach (char c in text)          // one event pair per UTF-16 unit
        {
            inputs.Add(MakeKey(c, KEYEVENTF_UNICODE));
            inputs.Add(MakeKey(c, KEYEVENTF_UNICODE | KEYEVENTF_KEYUP));
        }
        INPUT[] arr = inputs.ToArray();
        uint n = SendInput((uint)arr.Length, arr, Marshal.SizeOf(typeof(INPUT)));
        if (n != arr.Length) Say("SendInput sent " + n + "/" + arr.Length + " (err " + Marshal.GetLastWin32Error() + ")");
        return n;
    }

    static INPUT MakeKey(char c, uint flags)
    {
        INPUT i = new INPUT();
        i.type = INPUT_KEYBOARD;
        i.U.ki.wVk = 0;
        i.U.ki.wScan = c;
        i.U.ki.dwFlags = flags;
        i.U.ki.time = 0;
        i.U.ki.dwExtraInfo = IntPtr.Zero;
        return i;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct INPUT { public uint type; public InputUnion U; }

    // MOUSEINPUT is the largest member; including it keeps sizeof(INPUT) at the 40 bytes
    // SendInput expects on x64 (28 on x86).
    [StructLayout(LayoutKind.Explicit)]
    struct InputUnion
    {
        [FieldOffset(0)] public MOUSEINPUT mi;
        [FieldOffset(0)] public KEYBDINPUT ki;
        [FieldOffset(0)] public HARDWAREINPUT hi;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct MOUSEINPUT
    {
        public int dx, dy;
        public uint mouseData, dwFlags, time;
        public IntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct KEYBDINPUT
    {
        public ushort wVk, wScan;
        public uint dwFlags, time;
        public IntPtr dwExtraInfo;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct HARDWAREINPUT { public uint uMsg; public ushort wParamL, wParamH; }

    [DllImport("user32.dll", SetLastError = true)]
    static extern uint SendInput(uint nInputs, INPUT[] pInputs, int cbSize);

    [DllImport("user32.dll")]
    static extern short GetAsyncKeyState(int vKey);
}
'@

$CacheDir = Join-Path $env:LOCALAPPDATA 'sendtext'
$Exe      = Join-Path $CacheDir 'sendtext.exe'

function Get-SourceHash {
    $sha = [Security.Cryptography.SHA256]::Create()
    try { [BitConverter]::ToString($sha.ComputeHash([Text.Encoding]::UTF8.GetBytes($CSharp))).Replace('-', '') }
    finally { $sha.Dispose() }
}

function Test-ExeCurrent {
    if (-not (Test-Path $Exe)) { return $false }
    $stamp = "$Exe.hash"
    (Test-Path $stamp) -and ((Get-Content $stamp -Raw).Trim() -eq (Get-SourceHash))
}

# Preferred: the .NET SDK, which produces a native binary (~85ms start-up here).
function Build-WithSdk {
    if (-not (Get-Command dotnet -ErrorAction SilentlyContinue)) { return $false }
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("sendtext-" + [Guid]::NewGuid().ToString('N').Substring(0, 8))
    try {
        # Target the installed SDK's own major version; deriving it from the running
        # PowerShell would give "net4.0" under Windows PowerShell.
        $sdk = (& dotnet --version) 2>$null
        $major = if ($sdk -match '^(\d+)\.') { $Matches[1] } else { $null }
        if (-not $major) { return $false }
        $tfm = "net$major.0"
        New-Item -ItemType Directory $tmp -Force | Out-Null
        Set-Content -LiteralPath (Join-Path $tmp 'Program.cs') -Value $CSharp -Encoding UTF8
        # No RuntimeIdentifier: avoids a runtime-pack restore, and starts just as fast.
        Set-Content -LiteralPath (Join-Path $tmp 'sendtext.csproj') -Encoding UTF8 -Value @"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>WinExe</OutputType>
    <TargetFramework>$tfm</TargetFramework>
    <InvariantGlobalization>true</InvariantGlobalization>
    <AssemblyName>sendtext</AssemblyName>
    <Nullable>disable</Nullable>
    <ImplicitUsings>disable</ImplicitUsings>
  </PropertyGroup>
</Project>
"@
        $log = & dotnet build (Join-Path $tmp 'sendtext.csproj') -c Release -o $CacheDir --nologo 2>&1
        if ($LASTEXITCODE -ne 0) { Write-Verbose ($log -join "`n"); return $false }
        return $true
    }
    catch { Write-Verbose $_.Exception.Message; return $false }
    finally { Remove-Item $tmp -Recurse -Force -ErrorAction SilentlyContinue }
}

# Fallback: csc.exe from the in-box .NET Framework, present on every Windows install.
function Build-WithCsc {
    $csc = Get-ChildItem "$env:WINDIR\Microsoft.NET\Framework64\v4.0.30319\csc.exe",
                         "$env:WINDIR\Microsoft.NET\Framework\v4.0.30319\csc.exe" -ErrorAction SilentlyContinue |
           Select-Object -First 1 -ExpandProperty FullName
    if (-not $csc) { return $false }
    $src = [IO.Path]::GetTempFileName() + '.cs'
    try {
        Set-Content -LiteralPath $src -Value $CSharp -Encoding UTF8
        # /target:winexe => no console subsystem, so it can never flash a window.
        $log = & $csc /nologo /target:winexe /optimize /out:"$Exe" "$src" 2>&1
        if ($LASTEXITCODE -ne 0) { Write-Verbose ($log -join "`n"); return $false }
        return $true
    } finally { Remove-Item $src -Force -ErrorAction SilentlyContinue }
}

function Build-Exe {
    if (-not (Test-Path $CacheDir)) { New-Item -ItemType Directory $CacheDir -Force | Out-Null }
    $ok = Build-WithSdk
    if ($ok) { Write-Verbose 'built with the .NET SDK' } else { $ok = Build-WithCsc; if ($ok) { Write-Verbose 'built with csc.exe' } }
    if ($ok) { Set-Content -LiteralPath "$Exe.hash" -Value (Get-SourceHash) -Encoding ASCII }
    $ok
}

if ($ExePath) { $Exe; exit 0 }

if ($Build -or -not (Test-ExeCurrent)) {
    if (-not (Build-Exe)) {
        if ($Build) { throw 'Could not build: no .NET SDK and no csc.exe found.' }
        # Last resort: run the same code in-process. Slow to start, identical behaviour.
        Write-Verbose 'no compiler available - falling back to in-process Add-Type'
        if (-not ('Program' -as [type])) { Add-Type -TypeDefinition $CSharp -Language CSharp }
        $inproc = @($Text)
        if ($WaitMods -ge 0) { $inproc += @('--wait-mods', "$WaitMods") }
        if ($Dry)            { $inproc += '--dry' }
        if ($Log)            { $inproc += @('--log', $Log) }
        exit ([Program].GetMethod('Main', [Reflection.BindingFlags]'NonPublic,Static').Invoke($null, @(, [string[]]$inproc)))
    }
    if ($Build) { $Exe; exit 0 }
}

if (-not $Text) { throw 'Specify the text to send, e.g. .\send-text.ps1 U+00E5' }

$argv = @($Text)
if ($WaitMods -ge 0) { $argv += @('--wait-mods', "$WaitMods") }
if ($Dry)            { $argv += '--dry' }
if ($VerbosePreference -ne 'SilentlyContinue') { $argv += '--console' }
if ($Log)            { $argv += @('--log', $Log) }

$quoted = $argv | ForEach-Object { if ("$_" -match '\s') { '"' + $_ + '"' } else { "$_" } }
$p = Start-Process -FilePath $Exe -ArgumentList $quoted -NoNewWindow -Wait -PassThru
exit $p.ExitCode
