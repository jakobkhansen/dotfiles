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
# alias ff="\$($HOME/Documents/Scripts/fzf_navigate.py)"
alias ff="cd \$(fd . --type d | fuzz)"
alias c="clear"
alias size="du -sh "




# Shortcuts to dirs
alias h="cd ~"
alias n="nvim"

alias ranger='source ranger'
alias r=ranger
alias n=nvim
alias skhd="~/Documents/skhd/bin/skhd &; disown"
alias yabaireboot='launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"'

alias g="git"
alias gitview="gh repo view --web"
alias gv=gitview
alias gitroot="cd \$(git rev-parse --show-toplevel)"
alias gr=gitroot
alias gitbranch="git branch"
alias gb=gitbranch

alias darkmode="kitty +kitten themes --reload-in=all Tokyo Night Storm"
alias lightmode="kitty +kitten themes --reload-in=all Tokyo Night Day"

alias dotfiles='yadm'
alias pushdotfiles="yadm add -u && yadm commit -m 'Updates' && yadm push"
alias dotfilesg="nvim .local/share/yadm/repo.git -c 'Ge :'"

alias con="connect"
alias trackpad="bluetoothctl connect D4:57:63:5B:91:E7"
alias headset="bluetoothctl connect 88:C9:E8:37:EB:EB"
alias tp="trackpad"
alias hs="headset"

alias kattissubmit="~/Documents/Scripts/submit.py"

function open() {
    xdg-open "$1" &; disown
}

# MS
alias js="cd ~/Documents/1JS.git/checkouts"
