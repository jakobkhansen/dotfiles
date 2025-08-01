




# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        export ZSH="/usr/share/oh-my-zsh"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    export ZSH="$HOME/.oh-my-zsh"
fi

ZSH_THEME="powerlevel10k/powerlevel10k"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
source $HOME/.bash_aliases

# User configuration
bindkey -v


# Shift+tab
bindkey '^[[Z'  forward-char

bindkey -a '+' vi-end-of-line
bindkey '^W' backward-kill-word

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

KEYTIMEOUT=25

unsetopt histverify

# export JAVA_HOME=/usr/lib/jvm/java-20-openjdk
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=$HOME/.config/rofi/scripts:$PATH

function chpwd() {
    ls
}


export PATH="$HOME/.cargo/bin:$PATH"

# Vim bindings
bindkey -M vicmd ";" vi-rev-repeat-find
bindkey -M vicmd "," vi-repeat-find
# bindkey -M viins 'kj' vi-cmd-mode

# FZF theme
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' 
--color=fg:#c0caf5,bg:#24283b,hl:#bb9af7
--color=fg+:#c0caf5,bg+:#24283b,hl+:#7dcfff
--color=info:#7aa2f7,prompt:#7dcfff,pointer:#7dcfff 
--color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'

export GOPATH=$HOME/Documents/Dev/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
export VISUAL=nvim
export EDITOR=nvim
export MOZ_ENABLE_WAYLAND=1
export LIBRARY_PATH="$LIBRARY_PATH:$(brew --prefix)/lib"

# MS
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh --no-use"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
export RUSH_PNPM_STORE_PATH="$HOME/.odsp-build-cache"

export DISPLAY=127.0.0.1:0
export LIBGL_ALWAYS_INDIRECT=1
export GCM_CREDENTIAL_STORE=keychain
export TSC_WATCHFILE="UseFsEventsWithFallbackDynamicPolling"

export GPG_TTY=$(tty)
export MIDGARD_BACKFILL_CACHE_DIR="/Users/jakobhansen/.midgard-build-cache"
export USE_PRETTIER_ORGANIZE_IMPORTS=1


source ~/.torusrc

# Add .NET Core SDK tools
export PATH="$PATH:/Users/jakobhansen/.dotnet/tools"

export PATH="${PATH}:/Users/jakobhansen/.azureauth/0.8.4"

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/homebrew/lib/ruby/gems/3.3.0/bin:$PATH"


teamsAuth() {
export DOMOREEXP_NPM_AUTH_TOKEN=$(printf "protocol=https
host=domoreexp.visualstudio.com
path=DefaultCollection/teamspace/_git/_optimized/teams-modular-packages" | git credential fill | sed -n "/^password=/s/password=//p" | tr -d \n | base64)
}

# export PATH="/opt/homebrew/opt/node@18/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/node@18/lib"
export CPPFLAGS="-I/opt/homebrew/opt/node@18/include"
export PATH="${HOME}/.pyenv/shims:${PATH}"
