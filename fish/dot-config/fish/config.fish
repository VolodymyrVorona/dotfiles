if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -g fish_key_bindings fish_default_key_bindings

fish_add_path ~/.local/bin

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

if command -v zoxide &>/dev/null
    zoxide init fish | source
end
if command -v mise &>/dev/null
    mise activate fish | source
end

