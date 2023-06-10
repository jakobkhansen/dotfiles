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

# Master
alias nmaster="nvim -u ~/.config/nvim/masterinit.lua"
alias lsp="cd ~/Documents/Dev/LSP/CCDetect-lsp"
alias lsptest="cd ~/Documents/master-thesis/notes/TestCodebases"
alias thesis="cd ~/Documents/master-thesis/thesis; n thesis.tex"
alias defense="cd ~/Documents/master-thesis/defense; n defense.tex"
alias demo1="lsptest; cd WorldWindJava/; nmaster src/gov/nasa/worldwind/render/AbstractSurfaceShape.java -c '425'"

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

alias tt="taskwarrior-tui"

alias darkmode="kitty +kitten themes --reload-in=all Tokyo Night Storm"
alias lightmode="kitty +kitten themes --reload-in=all Tokyo Night Day"

alias dotfiles='yadm'
alias pushdotfiles="yadm add -u && yadm commit -m 'Updates' && yadm push"
alias dotfilesg="nvim .local/share/yadm/repo.git -c 'Ge :'"

alias monleft="xrandr --auto; xrandr --output HDMI-1 --left-of eDP-1"                                                                               
alias monright="xrandr --auto; xrandr --output HDMI-1 --right-of eDP-1"                                                                             
alias monup="xrandr --auto; xrandr --output HDMI-1 --above eDP-1"                                                                                   
alias mondup="xrandr --auto; xrandr --output HDMI-1 --same-as eDP-1"                                                                                

alias polyprimary="polybar PrimaryMonitor &; disown"
alias polysecondary="polybar SecondaryMonitor &; disown"

alias keyboardoverlay="screenkey -t 2 -s small --opacity 1 --window"

# Freebuds, Sony, Trackpad
function connect() {
    bluetoothctl connect 68:13:24:9C:40:F6 &
    bluetoothctl connect 88:C9:E8:37:EB:EB &
    bluetoothctl connect D4:57:63:5B:91:E7 &
    disown
}

alias con="connect"
alias trackpad="bluetoothctl connect D4:57:63:5B:91:E7"
alias headset="bluetoothctl connect 88:C9:E8:37:EB:EB"
alias tp="trackpad"
alias hs="headset"

function open() {
    xdg-open "$1" &; disown
}
