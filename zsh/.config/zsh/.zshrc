# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname "$ZINIT_HOME")"
	git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Variables
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export MANPAGER="nvim +Man!"
export EDITOR=nvim
export VISUAL=nvim
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export DBCLI_MYSQL="/usr/bin/mariadb"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/go/bin" ] ;
  then PATH="$HOME/go/bin:$PATH"
fi

if [[ -d "$HOME/.config/composer/vendor/bin" ]];
  then PATH="$HOME/.config/composer/vendor/bin:$PATH"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Source/Load zsh functions
source "$ZDOTDIR/functions.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Load completions
autoload -U compinit && compinit


# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

# History
HISTSIZE=5000
HISTFILE="${ZDOTDIR:-${HOME}}/.zsh_history"

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls="eza"
alias la="ls -a"
alias ll="ls -al --group-directories-first --icons=always"
alias lt="la -T --level=3"
alias ld="ls -lD --icons=always"
alias lf="ls -lf --color=always --icons | grep -v /"
alias lh="ls -dl .* --group-directories-first --icons=always"

alias lvim='NVIM_APPNAME="lazyvim" nvim'
alias avim='NVIM_APPNAME="astronvim" nvim'
alias lzd="lazydocker"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
