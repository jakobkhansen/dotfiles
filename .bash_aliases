# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Custom alias list

alias ll='ls -a'
alias la='ls -A'
alias l='ls'
alias ff="\$($HOME/Documents/Scripts/fzf_navigate.py)"
alias c="clear"
alias size="du -sh "

alias dagens="/home/jakob/Documents/Personal/Middag-IFI/middag.py"

alias cd="cs"

# Change directory and ls
function cs () {
	builtin cd "$@" && ls
}

alias h="cd ~"
alias ranger='source ranger'
alias r=ranger
alias n=nvim

alias kattispy="/home/jakob/Documents/Personal/KattisSolutions/kattis_shell_python.sh"
alias kattissubmit="/home/jakob/Documents/Scripts/submit.py"
alias kotlinrun="/home/jakob/Documents/Scripts/kotlinrun.py"


alias dotfiles='/usr/bin/git --git-dir=/home/jakob/.dotfiles/ --work-tree=/home/jakob'
alias pushdotfiles="dotfiles add -u && dotfiles commit -m 'Updates' && dotfiles push"
alias pushschool="cd /home/jakob/Documents/School; git add .; git commit -m 'Updates'; git push"
alias gitview="gh repo view --web"
alias gitroot="cd \$(git rev-parse --show-toplevel)"

alias serve="browser-sync start -s -f . "

function gitpush() {
    git add -u 
    git commit -m $1
    git push
}

alias orphans="yay -Rns \$(yay -Qtdq)"

alias open="echo -ne '\n' | xdg-open $1 > /dev/null 2>&1"

alias latexinit="/home/jakob/Documents/Scripts/latextemplate.sh $1"


alias sxiv="sxiv -a"

alias cal="cal -m -y"

alias tlmgr="/usr/share/texmf-dist/scripts/texlive/tlmgr.pl --usermode"

alias anaconda="export PATH=\"$HOME/.config/anaconda3/bin:\$PATH\""

alias drag="dragon-drag-and-drop"

alias monleft="xrandr --auto; xrandr --output HDMI-1 --left-of eDP-1"
alias monright="xrandr --auto; xrandr --output HDMI-1 --right-of eDP-1"
alias monup="xrandr --auto; xrandr --output HDMI-1 --above eDP-1"
alias mondup="xrandr --auto; xrandr --output HDMI-1 --same-as eDP-1"


alias pm2start="pm2 start npm -- start --restart-delay=3000"
alias pm2restart="pm2 delete npm && sleep 3 && pm2start"
