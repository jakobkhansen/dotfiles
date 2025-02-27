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

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-Alias h GoHome -Option AllScope
Set-Alias n nvim
Set-Alias g git
Set-Alias l Ls
Set-Alias ff FuzzDir
Set-Alias dotfiles Dfiles -Option AllScope
Set-Alias r yazi
