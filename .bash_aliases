# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -a'
alias la='ls -A'
alias l='ls'

# Custom alias list
alias uiologin="ssh jakobkha@login.ifi.uio.no"
alias uio="/home/jakob/Scripts/uio.sh; cd /home/jakob/Documents/UiOServer"
alias dagens="/home/jakob/Documents/dev/Personal/MiddagIFI/middag.py"

alias cd="cs"
alias h="cd ~"
alias ranger='source ranger'
alias r=ranger
alias n=nvim

alias kattispy="/home/jakob/Documents/dev/Personal/KattisSolutions/kattis_shell_python.sh"$1
alias kattiskotlin="/home/jakob/Documents/dev/Personal/KattisSolutions/kattis_shell_kotlin.sh"$1
alias kattists="/home/jakob/Documents/dev/Personal/KattisSolutions/kattis_shell_typescript.sh"$1
alias kotlinrun="/home/jakob/Scripts/kotlinrun.sh"$1

alias dotfiles='/usr/bin/git --git-dir=/home/jakob/.dotfiles/ --work-tree=/home/jakob'
alias pushdotfiles="dotfiles add -u && dotfiles commit -m 'Updates' && dotfiles push"
alias sshpi="ssh pi@raspberrypi.local"
alias pushschool="cd /home/jakob/Documents/School; git add .; git commit -m 'Updates'; git push"
alias gitview="gh repo view --web"

function gitpush() {
    git add -u 
    git commit -m $1
    git push
}

alias orphans="yay -Rns \$(yay -Qtdq)"

alias editbashrc="nvim ~/.bashrc"
alias editaliases="nvim ~/.bash_aliases"
alias editvim="nvim ~/.config/nvim/init.vim"
alias editkitty="nvim ~/.config/kitty/kitty.conf"
alias editranger="nvim ~/.config/ranger/rc.conf"
alias editzsh="nvim ~/.config/zsh/.zshrc"
alias editpolybar="nvim ~/.config/polybar/config"

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

alias cal="cal -m -y"

alias cattc="python /home/jakob/Documents/dev/Personal/CattCommand/src/main.py"
alias castlofi="catt cast 'https://www.youtube.com/watch?v=-5KAN9_CzSA'"

alias canvas="/home/jakob/Scripts/canvas.py"

alias tlmgr="/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode"

alias anaconda="export PATH=\"$HOME/.config/anaconda3/bin:\$PATH\""

alias drag="dragon-drag-and-drop"
alias kattissubmit="/home/jakob/Scripts/submit.py"

function presentation () {
    zathura --mode "presentation" "$1"
}

function castrandom () {
    /home/jakob/Scripts/castrandom.py $@
}

function moviecommentary() {
    /home/jakob/Scripts/CommentaryMovie.sh $@
}

function search() {
    sudo -E find $1 -iname "*$2*"
}

function javarun() {
    javac $1 && java $(echo $1 | cut -d'.' -f1) && rm *.class
}


# Change directory and ls
function cs () {
	builtin cd "$@" && ls
}

function mdpreview() {
    markdown=`cat $1`
    instant-markdown-d --mathjax &
    sleep 3
    curl -X PUT --data "$markdown" http://localhost:8090/
    echo $1
    disown
}
