# dotfiles
Bare git repo for personal config files.

# Install on new machine

```bash
gh repo clone jakobkhansen/dotfiles $HOME/.dotfiles
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles checkout
dotfiles config --local status.showUntrackedFiles no
```
