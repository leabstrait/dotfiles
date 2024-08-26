#  ███████████    █████████    █████████  █████   █████
# ░░███░░░░░███  ███░░░░░███  ███░░░░░███░░███   ░░███
#  ░███    ░███ ░███    ░███ ░███    ░░░  ░███    ░███
#  ░██████████  ░███████████ ░░█████████  ░███████████
#  ░███░░░░░███ ░███░░░░░███  ░░░░░░░░███ ░███░░░░░███
#  ░███    ░███ ░███    ░███  ███    ░███ ░███    ░███
#  ███████████  █████   █████░░█████████  █████   █████
# ░░░░░░░░░░░  ░░░░░   ░░░░░  ░░░░░░░░░  ░░░░░   ░░░░░

# Exit if any command fails, if an unset variable is used, or if a pipeline fails
# set -euo pipefail

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH configuration
export PATH="$HOME/.local/bin:$HOME/dotfiles:$PATH"

# Bash options
shopt -s autocd                  # Automatically cd to a directory if only its path is entered
shopt -s checkwinsize            # Update LINES and COLUMNS after terminal resize
shopt -s cdspell                 # Correct minor cd typos
shopt -s histappend              # Append to the history file, don't overwrite
shopt -s cmdhist                 # Save multi-line commands in a single history entry
shopt -s extglob                 # Enable extended pattern matching
shopt -s no_empty_cmd_completion # No empty completions

# Prompt
eval "$(starship init bash)"
export SUDO_PROMPT=$'\e[38;2;207;34;46mPassword:\e[0m ' # Make the sudo prompt simpler and colorful

# Environment variables

# History settings
export HISTFILE=~/.bash_history
export HISTSIZE=1000
export SAVEHIST=500
export HISTCONTROL=ignoreboth:erasedups

# Source additional scripts from .bashrc.d directory
for file in $HOME/.bashrc.d/*.bashrc; do
    [ -f "$file" ] && source "$file"
done

# tmux sessions using fzf
bind -x '"\es": fztmx' # Esc + s for fuzzy tmux sessions

# Automatically run fztmx if available and not in a tmux session or screen
if command -v tmux &>/dev/null && command -v fztmx &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec fztmx && exit
fi

# System Information
fastfetch
