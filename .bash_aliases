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
alias ff="cd \$(fd . --type d --max-results 10000 | fzf)"
alias c="clear"
alias size="du -sh "




# Shortcuts to dirs
alias h="cd ~"
alias n="nvim"

alias ranger='source ranger'
alias r=ranger
alias n=nvim
alias yabaireboot='launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"'

alias g="git"
alias gs="git status"
alias gitview="gh repo view --web"
alias gv=gitview
alias gitroot="cd \$(git rev-parse --show-toplevel)"
alias gr=gitroot
alias gitbranch="git branch"
alias gb=gitbranch
alias gp="git pull"
alias gwt="git worktree"

alias darkmode="kitty +kitten themes --reload-in=all Tokyo Night Storm"
alias lightmode="kitty +kitten themes --reload-in=all Tokyo Night Day"

alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias pushdotfiles="dotfiles add -u && dotfiles commit -m 'Updates' && dotfiles push"
alias dotfilesg="nvim ~/.dotfiles -c 'Ge :'"
alias dotfilesg="GIT_DIR=$HOME/.dotfiles GIT_WORK_TREE=$HOME nvim ~/.dotfiles -c 'Ge :'"

alias con="connect"
alias trackpad="bluetoothctl connect D4:57:63:5B:91:E7"
alias headset="bluetoothctl connect 88:C9:E8:37:EB:EB"
alias tp="trackpad"
alias hs="headset"

alias kattissubmit="~/Documents/Scripts/submit.py"
alias dotnet-csharpier="dotnet csharpier"

# MS
alias learn="cd ~/Documents/Learning"

alias yf="yarn fast"
alias ys="yarn start"
alias yb="yarn build"
alias ybs="yarn build-scope"
alias yt="yarn test"
alias yg="yarn generate"

yfbs() {
    yarn fast $1
    yarn build-scope $1
}

wt() {
    cd ~/Documents/1JS/checkouts/main
    git pull origin main
    cd ..
    git worktree add -b user/jakobhansen/$1 $1
    cd $1/midgard 
    yarn fast org-explorer-app
    yarn build-scope org-explorer-app
}

review() {
    cd ~/Documents/1JS/checkouts
    git fetch origin $1:$1
    git worktree add $1 $1
    cd $1/midgard 
    yarn fast org-explorer-app
}

alias jsr="cd ~/Documents/1JS/checkouts"

js() {
    cd ~/Documents/1JS/
    worktree=$(git worktree list | grep -v "(bare)" | tail -r | fzf | awk '{print $1}')
    cd $worktree/midgard/packages
    packages="org-explorer-app\n.. (midgard)\n../.. (1js)\n${$(ls | grep -v "org-explorer-app$")}"
    cd $(echo $packages | fzf | awk '{print $1;}')
}

asg() {
    cd ~/Documents/Asgard/
}

xcleanworktreesx() {
    cd ~/Documents/1JS/
    worktrees=$(git worktree list | grep -v "(bare)" | grep -v "main" | cut -f 1 -d " ")
    worktreelist=$(echo $worktrees | tr "\n" "\n")
    echo $worktreelist
    while IFS= read -r line; do
        echo "Deleting worktree $line"
        git worktree remove $line -f
    done <<< "$worktrees"
    git branch | grep -v "main" | xargs git branch -D
    git worktree prune
    git gc
}

xcleanunusedbranchesx() {
    git branch | grep -v "+" | grep -v "*" | xargs git branch -D
}
