if not command -v fzf &>/dev/null
    return
end

# Tokyonight Night theme
set -gx FZF_DEFAULT_OPTS "\
    --color=bg+:#283457,bg:#16161e,spinner:#bb9af7,hl:#7aa2f7 \
    --color=fg:#c0caf5,header:#7aa2f7,info:#7dcfff,pointer:#bb9af7 \
    --color=marker:#9ece6a,fg+:#c0caf5,prompt:#bb9af7,hl+:#7aa2f7 \
    --color=selected-bg:#283457 \
    --color=border:#27a1b9,label:#7aa2f7 \
    --highlight-line \
    --height=20 \
    --layout=reverse --border=rounded \
    --preview-window=right:50%:border-left \
    --bind='ctrl-/:toggle-preview'"

# Ctrl+T: file search with preview
set -gx FZF_CTRL_T_OPTS "\
    --preview 'test -d {} && eza -T --level=2 --color=always --icons=always {} || bat --color=always --style=numbers --line-range=:200 {}' \
    --preview-window=right:60%:border-left"

# Alt+C: directory search with tree preview
set -gx FZF_ALT_C_OPTS "\
    --preview 'eza -T --level=2 --color=always --icons=always {}' \
    --preview-window=right:50%:border-left"

# Ctrl+R: history search
set -gx FZF_CTRL_R_OPTS "\
    --preview 'echo {}' --preview-window=up:3:hidden:wrap \
    --bind 'ctrl-/:toggle-preview'"

fzf --fish | source
