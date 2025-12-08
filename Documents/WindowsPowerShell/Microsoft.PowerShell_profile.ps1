Remove-Item Alias:r

# For keeping CWD when duplicating tab
function prompt {
  $loc = $executionContext.SessionState.Path.CurrentLocation;

  $out = ""
  if ($loc.Provider.Name -eq "FileSystem") {
    $out += "$([char]27)]9;9;`"$($loc.ProviderPath)`"$([char]27)\"
  }
  $out += "PS $loc$('>' * ($nestedPromptLevel + 1)) ";
  return $out
}

Set-PSReadlineKeyHandler -Key Tab -Function Complete

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

function r {
    $tmp = (New-TemporaryFile).FullName
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
    }
    Remove-Item -Path $tmp
}
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-Alias h GoHome -Option AllScope
Set-Alias n nvim
Set-Alias g git
Set-Alias l Ls
Set-Alias ff FuzzDir
Set-Alias dotfiles Dfiles -Option AllScope
