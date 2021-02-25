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
alias dagens="/home/jakob/Documents/Personal/Middag-IFI/middag.py"

alias cd="cs"
alias h="cd ~"
alias ranger='source ranger'
alias r=ranger
alias n=nvim

alias kattispy="/home/jakob/Documents/Personal/KattisSolutions/kattis_shell_python.sh"$1
alias kattissubmit="/home/jakob/Scripts/submit.py"


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
alias doom="/home/jakob/.emacs.d/bin/doom"

alias open="echo -ne '\n' | xdg-open $1 > /dev/null 2>&1"

alias latexinit="/home/jakob/Scripts/latextemplate.sh $1"

alias editi3="nvim /home/jakob/.config/i3/config"

alias c="clear"

alias sxiv="sxiv -a"

alias cal="cal -m -y"

alias tlmgr="/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode"

alias anaconda="export PATH=\"$HOME/.config/anaconda3/bin:\$PATH\""

alias drag="dragon-drag-and-drop"

function presentation () {
    zathura --mode "presentation" "$1"
}

function castrandom () {
    /home/jakob/Scripts/castrandom.py $@
}

function javarun() {
    javac $1 && java $(echo $1 | cut -d'.' -f1) && rm *.class
}


# Change directory and ls
function cs () {
	builtin cd "$@" && ls
}
