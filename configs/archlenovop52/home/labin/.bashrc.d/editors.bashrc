# Editors, viewers, and related functions

# Edit environment settings
export WORDCHARS=${WORDCHARS//\/[&.;]/} # Exclude certain characters from word boundaries
export PROMPT_EOL_MARK=''               # Remove the trailing % at the end of newlines

# Less configuration
export LESS="-S -R -F --incsearch --mouse --use-color -Dd+30 -Du+33 -Ds+99"

# Colorize man pages with less
export MANPAGER="less -DE255.160 -DP255.29 -DS255.33"
export MANROFFOPT="-P -c"

# Default editor
export EDITOR=code

# Function to run help or man page
function run-help() {
    help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"
}
bind -m emacs -x     '"\eh": run-help' # Alt + h for help or manpage


# Use bat instead of cat
alias cat="bat"
