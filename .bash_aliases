# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto --group-directories-first'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Custom alias list
alias l='ls'
alias ff="cd \$(fd . --type d | fzf)"
alias c="clear"
alias n="nvim"


# Shortcuts to dirs
alias h="cd ~"
alias xdg-open="open"

alias ranger='source ranger'
alias r=ranger
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
alias gbc="git checkout -b"

gwta() {
    git worktree add $1 user/jakobhansen/$1
}

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

alias y="yarn"
alias yf="yarn fast"
alias ys="yarn start"
alias yb="yarn build"
alias ybs="yarn build-scope"
alias yt="yarn test"
alias yg="yarn generate"
alias ygr="yarn generate:relay"
alias ypr="yarn prepare"

# package root
pr() {
    count=`ls -1 package.json 2>/dev/null | wc -l`
    while [ $count -eq 0 ] && [ $(pwd) != "/" ]
    do
        cd ..
        count=`ls -1 package.json 2>/dev/null | wc -l`
    done
}

# Run yarn command for current package
yp() {
    cwd=$(pwd)
    pr
    package=$(basename "$PWD")
    cd .. > /dev/null
    yarn $1 $package
    cd $cwd > /dev/null
}

# yarn fast for current package
yfp() {
    yp "fast"
}

# yarn build-scope for current package
ybp() {
    yp "build-scope"
}

yfbs() {
    yarn fast $1
    yarn build-scope $1
}


wt() {
    root=$(git rev-parse --show-toplevel 2>/dev/null || eval echo "~/Documents/1JS/checkouts/main")
    echo "Checkout branch: $root"
    cd $root > /dev/null
    git pull
    git branch user/jakobhansen/$1
    cd ~/Documents/1JS/checkouts
    git worktree add $1 user/jakobhansen/$1
    cd $1/midgard 
    yarn fast lpc-outlook-web
    yarn build-scope lpc-outlook-web
}

review() {
    cd ~/Documents/1JS/checkouts
    git fetch origin $1:$1
    git worktree add $1 $1
    cd $1/midgard 
    yarn fast lpc-outlook-web
}

alias jsr="cd ~/Documents/1JS/checkouts"

js() {
    cd ~/Documents/1JS/
    worktree=$(git worktree list | grep -v "(bare)" | tail -r | fzf | awk '{print $1}')
    cd $worktree/midgard/packages
    packages="conversation-recap-nova\nlpc-copilot-tab\nlpc-outlook-web\norg-explorer-app\n.. (midgard)\n../.. (1js)\n${$(ls | grep -v "org-explorer-app$")}"
    cd $(echo $packages | fzf | awk '{print $1;}')
}

jsp() {
    root=$(git rev-parse --show-toplevel 2>/dev/null || eval echo "~/Documents/1JS/checkouts/main")
    echo $root
    cd $root/midgard/packages
    packages="conversation-recap-nova\nlpc-copilot-tab\nlpc-outlook-web\norg-explorer-app\n.. (midgard)\n../.. (1js)\n${$(ls | grep -v "org-explorer-app$")}"
    cd $(echo $packages | fzf | awk '{print $1;}')
}

asg() {
    cd ~/Documents/Asgard/
}

gitopen() {
    remote=$(git remote -v | grep fetch | awk '{print $2}')
    gitroot=$(git rev-parse --show-toplevel 2>/dev/null);
    if [ $# -eq 0 ]
    then
        file=$(echo $(pwd) | sed "s~$gitroot~~g")
    else
        file=$(echo $(realpath $1) | sed "s~$gitroot/~~g")
    fi

    # Replace with branch=$(git branch --show-current) if you want current branch
    branch="main"

    if [[ $remote == *"github.com"* ]]; then
        repo=$(echo $remote | sed -e 's/.*:\(.*\)\.git.*/\1/')
        url="https://www.github.com/$repo/tree/$branch/$file"
        open $url
    elif [[ $remote == *"azure.com"* ]]; then
        repo=$(echo $remote | sed 's/@dev.azure/.visualstudio/g')
        url="$repo?path=$file&version=GB$branch"
        open $url
    else
        echo "Unknown repo type"
    fi
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
