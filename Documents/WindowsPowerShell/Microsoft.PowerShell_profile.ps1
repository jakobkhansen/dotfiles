Import-Module PSReadline
Remove-Item Alias:r

function prompt {
  $loc = $executionContext.SessionState.Path.CurrentLocation;

  $out = ""
  if ($loc.Provider.Name -eq "FileSystem") {
    $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }
  $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
  return $out
}

Set-PSReadLineKeyHandler -Key Ctrl+d -Function ViExit

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# enable up/down arrows for navigating through the history

Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# moves the cursor to the end of the autocompleted command (remove if you want the cursor to remain where the completion started from)

Set-PSReadLineOption -HistorySearchCursorMovesToEnd

# enable zsh autocompletion like auto completion

Set-PSReadlineOption -PredictionSource History

function GoHome {
    cd ~
}

function Ls {
    ls
}

function Dfiles {
    git --git-dir=C:\Users\jakobhansen\.dotfiles --work-tree=C:\Users\jakobhansen $args
}

function FuzzDir {
    cd $(fzf --walker=dir)
}

function pushdotfiles {
    dotfiles add -u
    dotfiles commit -m "Updates"
    dotfiles push
}

function r {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}

function keeb {
    & "$HOME\Documents\Kanata\kanata_windows_gui_winIOv2_cmd_allowed_arm64.exe" `
      -c "$HOME\Documents\colemak-jkl\kanata\kanata.kbd"
}

$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-Alias h GoHome -Option AllScope
Set-Alias n nvim
Set-Alias g git
Set-Alias l Ls
Set-Alias ff FuzzDir
Set-Alias dotfiles Dfiles -Option AllScope


# MS stuff

function cr {
    cd ~/Documents/Copilot-Dash/checkouts
}

$default_fzf_order = ".. (root)`n"

function cf {
    Set-Location "$HOME\Documents\Copilot-Dash"

    $worktree = git worktree list |
        Where-Object { $_ -notmatch "\(bare\)" } |
        fzf |
        ForEach-Object { ($_ -split '\s+')[0] }

    if (-not $worktree) { return }

    Set-Location (Join-Path $worktree "sources")

    $packages = $default_fzf_order + (
        Get-ChildItem |
        Select-Object -ExpandProperty Name |
        Out-String
    )

    $choice = $packages | fzf
    if (-not $choice) { return }

    # Match bash behavior: cd ".." when ".. (root)" is selected
    if ($choice -like "..*") {
        Set-Location ..
    } else {
        Set-Location $choice
    }
}

function wt {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Name
    )
    $root = git rev-parse --show-toplevel 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $root) {
        $root = "$HOME\Documents\Copilot-Dash\checkouts\master"
    }

    Write-Host "Checkout branch: $root"

    Set-Location $root
    git pull

    git branch "user/jakobhansen/$Name"

    Set-Location "$HOME\Documents\Copilot-Dash\checkouts"
    git worktree add $Name "user/jakobhansen/$Name"

    Set-Location (Join-Path $Name "sources")

    $packages = $default_fzf_order + (
        Get-ChildItem |
        Select-Object -ExpandProperty Name |
        Out-String
    )

    $choice = $packages | fzf
    if (-not $choice) { return }

    if ($choice -like "..*") {
        Set-Location ..
    } else {
        Set-Location $choice
    }
}

