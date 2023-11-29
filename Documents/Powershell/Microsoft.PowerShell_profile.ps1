function GoHome {
    cd ~
}

function Dfiles {
    git --git-dir=C:\Users\jakobhansen\.dotfiles --work-tree=C:\Users\jakobhansen $args
}

Set-Alias h GoHome -Option AllScope
Set-Alias n nvim
Set-Alias g git
Set-Alias dotfiles Dfiles -Option AllScope
