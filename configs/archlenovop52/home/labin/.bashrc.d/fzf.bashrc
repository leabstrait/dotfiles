# Source fzf
eval "$(fzf --bash)"

# fzf options
export FZF_DEFAULT_OPTS="
    --padding 1%
    --border sharp
    --separator="─"
    --scrollbar="║"
    --border-label '╢ fuzzy finder ╟'
    --border-label-pos '-5'
    --preview-window 'border-sharp'
    --info inline-right:'matched (sel) '
    --prompt '▶ '
    --pointer ' ⟹'
    --marker '● '
    --layout reverse
    --bind '?:toggle-preview'
    --bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'
    --bind 'change:top'
    --header-first
    --header 'fzf

CTRL-c or ESC: quit
CTRL-Y: copy selection into clipboard
?: toggle preview (if available)

'
"

# colors (GitHub Light)
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
    --color bg:#ffffff,fg:#1f2328
    --color bg+:#ffffff,fg+:#0969da
    --color header:#1b7c83
    --color label:#1b7c83
    --color border:#1f2328,preview-border:#1f2328
    --color scrollbar:#1b7c83,preview-scrollbar:#1b7c83
    --color pointer:#0969da,marker:#0969da,spinner:#1b7c83
    --color prompt:#0969da,info:#1b7c83
    --color hl:#a40e26,hl+:#cf222e
    --color separator:#1f2328
"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --preview-window 'down:3:hidden:wrap'
    --height 70%
"

export FZF_ALT_C_OPTS="
    --preview 'eza --color=always --tree {}'
    --height 70%
"

export FZF_CTRL_T_OPTS="
    --preview '(bat --color=always {} || eza --color=always --tree {}) 2> /dev/null'
    --height 70%
"

# fzf and paru
fzpm() {
    # Command to list all packages with colored tick mark
    list_cmd="paru -Sl | awk '{print (\$4 == \"[installed]\" ? \"\\033[38;2;26;127;55m✔\\033[0m\" : \"▫\") \" \" \$2, \"(\"\$1\")\"}'"

    # Command to preview package information
    preview_cmd="pkg={2}; repo={3}; if paru -Qi \"\$pkg\" &>/dev/null; then paru -Qi \"\$pkg\" && paru -Ql \"\$pkg\" | awk '{print \$2}'; elif [[ \"\$repo\" != *\"aur\"* ]]; then paru -Si \"\$pkg\" && paru -Fl \"\$pkg\" | awk '{print \$2}'; else paru -Si \"\$pkg\"; fi"

    # Command to remove marked packages
    remove_cmd="tmux display-popup -E 'echo \"Removing: {+2}\" && read -p \"Press Enter to confirm or Ctrl-C to cancel...\"; if [ -n \"{+2}\" ]; then paru -Rcnsuv {+2}; fi'"

    # Command to install marked packages
    install_cmd="tmux display-popup -E 'echo \"Installing: {+2}\" && read -p \"Press Enter to confirm or Ctrl-C to cancel...\"; if [ -n \"{+2}\" ]; then paru -S {+2}; fi'"

    # Bind keys to actions
    bind_keys=(
        "--bind=del:execute-silent($remove_cmd)"
        "--bind=del:+reload($list_cmd)"
        "--bind=del:+refresh-preview"
        "--bind=enter:execute-silent($install_cmd)"
        "--bind=enter:+reload($list_cmd)"
        "--bind=enter:+refresh-preview"
    )

    # Execute fzf with the above components
    eval "$list_cmd" | fzf \
        --ansi \
        --multi \
        --delimiter " " --nth 2 \
        --preview "$preview_cmd" \
        --prompt "pkgs ▶ " \
        "${bind_keys[@]}" \
        --header "fuzzy package manager

Enter: (re)install marked packages
Del: remove marked packages

"
}

# fzf and tmux sessions
fztmx() {
    # List all sessions except the current one
    list_cmd="tmux list-sessions"

    # Command to preview the session (show pane contents)
    preview_cmd="session_name=\$(echo '{1}' | cut -d: -f1 | tr -d '\n'); tmux capture-pane -ep -t \"\$session_name\""

    # Command to remove a session
    remove_cmd="session_name=\$(echo '{1}' | cut -d: -f1 | tr -d '\n'); tmux display-popup -E \"echo 'Removing session: \$session_name' && read -p 'Press Enter to confirm or Ctrl-C to cancel...'; if [ -n '\$session_name' ]; then tmux kill-session -t '\$session_name'; fi\""

    # Bind keys to actions
    bind_keys=(
        "--bind=enter:accept-or-print-query"
        "--bind=del:execute-silent($remove_cmd)"
        "--bind=del:+reload($list_cmd)"
        "--bind=del:+refresh-preview"
    )

    # Execute fzf with the above components
    selected=$(eval "$list_cmd" | fzf \
        --ansi \
        --delimiter " " --nth 1 \
        --preview "$preview_cmd" \
        --prompt "sessions ▶ " \
        "${bind_keys[@]}" \
        --header "tmux session switcher

Enter: switch to selected session or create if not found
Del: remove selected session

")

    # Check if fzf was interrupted or no session was selected
    if [ $? -ne 0 ]; then
        return 0
    fi

    # Check if a valid session was selected or a new name was provided
    if [ -n "$selected" ]; then
        # Clean up selected session name
        selected=$(echo "$selected" | cut -d: -f1 | tr -d '\n')

        if tmux list-sessions | grep -q "^$selected"; then
            # Switch to the selected session
            if [ -n "$TMUX" ]; then
                tmux switch-client -t "$selected" &&
                    tmux list-clients -F '#{client_name}' |
                    grep -v "$(tmux display-message -p '#{client_name}')" |
                        xargs -I {} tmux detach-client -t {}
            else
                tmux attach-session -d -t "$selected"
            fi
        else
            # Create a new session if the selected session doesn't exist
            if [ -n "$TMUX" ]; then
                tmux new-session -ds "$selected" && tmux switch-client -t "$selected"
            else
                tmux new-session -s "$selected"
            fi
        fi
    else
        # No selection, create a new session
        if [ -n "$TMUX" ]; then
            tmux new-session -d && tmux switch-client -n
        else
            tmux new-session
        fi
    fi
}
