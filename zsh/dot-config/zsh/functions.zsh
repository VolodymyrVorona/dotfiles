lg()
{
    export LAZYGIT_NEW_DIR_FILE="$HOME/.lazygit/newdir"

    lazygit "$@"

    if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f "$LAZYGIT_NEW_DIR_FILE" > /dev/null
    fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
