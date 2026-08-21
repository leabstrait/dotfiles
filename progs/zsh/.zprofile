# =====================================================================
# .zprofile - System Environment Initialization (macOS & Arch Linux)
# =====================================================================

# --- Platform-Specific Package Manager Initialization ---
case "$(uname -s)" in
    Darwin)
        export HOMEBREW_NO_ANALYTICS=1
        if [ -x /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv zsh)"
        elif [ -x /usr/local/bin/brew ]; then
            eval "$(/usr/local/bin/brew shellenv zsh)"
        fi
        ;;
    Linux)
        # Arch Linux native profile configurations
        ;;
esac