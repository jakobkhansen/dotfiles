# some more ls aliases
alias ll='ls -alF --block-size=M'
alias la='ls -A'
alias l='ls'

# Custom alias list
alias uiologin="ssh jakobkha@login.ifi.uio.no"
alias uio="/home/jakob/Scripts/uio.sh; cd /home/jakob/Documents/UiOServer"
alias dagens="/home/jakob/Documents/dev/Personal/MiddagIFI/middag.py"

alias cd="cs"
alias h="cd ~"
alias ranger='source ranger'

alias kattispy="/home/jakob/Documents/dev/Personal/KattisSolutions/kattis_shell_python.sh"$1
alias kattiskotlin="/home/jakob/Documents/dev/Personal/KattisSolutions/kattis_shell_kotlin.sh"$1
alias kattists="/home/jakob/Documents/dev/Personal/KattisSolutions/kattis_shell_typescript.sh"$1
alias rkotlin="/home/jakob/Scripts/kotlinrun.sh"$1

alias dotfiles='/usr/bin/git --git-dir=/home/jakob/.dotfiles/ --work-tree=/home/jakob'
alias pushdotfiles="dotfiles add -u && dotfiles commit -m 'Updates' && dotfiles push"
alias sshpi="ssh pi@raspberrypi.local"
alias pushschool="cd /home/jakob/Documents/Skole; git add .; git commit -m 'Updates'; git push"

alias orphans="yay -Rns \$(yay -Qtdq)"

alias editbashrc="nvim ~/.bashrc"
alias editvim="nvim ~/.config/nvim/init.vim"
alias editkitty="nvim ~/.config/kitty/kitty.conf"

alias hotkeys="sudo python3 ~/Scripts/hotkeys.py"
alias updaterunelite="~/Documents/dev/Personal/ArchUpdateRunelite/UpdateRuneLite.sh"

alias open="echo -ne '\n' | xdg-open $1 > /dev/null 2>&1"

alias latexinit="/home/jakob/Scripts/latextemplate.sh $1"

alias emoji="tuimoji"

alias editi3="nvim /home/jakob/.config/i3/config"
alias i3-restart="i3-msg restart"

alias c="clear"

alias record="/home/jakob/Scripts/recordscreen.sh"

alias wifirestart="sudo systemctl restart NetworkManager"

alias sxiv="sxiv -a"

alias cal="cal -y"

alias cattc="python /home/jakob/Documents/dev/Personal/CattCommands/src/main.py"

export NVM_DIR="/home/jakob/.nvm"
export ANDROID_HOME=/home/jakob/Android/Sdk/
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# Change directory and ls
function cs () {
	builtin cd "$@" && ls
}


export EDITOR=nvim
