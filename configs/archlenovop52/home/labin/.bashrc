#  ███████████    █████████    █████████  █████   █████
# ░░███░░░░░███  ███░░░░░███  ███░░░░░███░░███   ░░███
#  ░███    ░███ ░███    ░███ ░███    ░░░  ░███    ░███
#  ░██████████  ░███████████ ░░█████████  ░███████████
#  ░███░░░░░███ ░███░░░░░███  ░░░░░░░░███ ░███░░░░░███
#  ░███    ░███ ░███    ░███  ███    ░███ ░███    ░███
#  ███████████  █████   █████░░█████████  █████   █████
# ░░░░░░░░░░░  ░░░░░   ░░░░░  ░░░░░░░░░  ░░░░░   ░░░░░

#set -euo pipefail

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# source all files in .bashrc.d directory
for file in $HOME/.bashrc.d/*.bashrc; do
    source $file
done

if command -v tmux &>/dev/null && command -v fztmx &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    fztmx && exit
fi

# PATH
export PATH="$HOME/.local/bin:$HOME/dotfiles:$PATH"

# Options
shopt -s autocd                  # if only directory path is entered, cd there.
shopt -s checkwinsize            # check window size and set values for LINES and COLUMNS
shopt -s cdspell                 # Correct cd typos
shopt -s checkwinsize            # Update windows size on command
shopt -s histappend              # Append History instead of overwriting file
shopt -s cmdhist                 # Bash attempts to save all lines of a multiple-line command in the same history entry
shopt -s extglob                 # Extended pattern
shopt -s no_empty_cmd_completion # No empty completion

# Run help
function run-help() {
    help "$READLINE_LINE" 2>/dev/null || man "$READLINE_LINE"
}
bind -m vi-insert -x '"\em": run-help' # Esc + m for manpage

# Command not found, suggest package
source /usr/share/doc/pkgfile/command-not-found.bash

# Environment variables

# History settings
HISTFILE=~/.bash_history
HISTSIZE=1000
SAVEHIST=500
HISTCONTROL=ignoreboth:erasedups

# Other settings
WORDCHARS=${WORDCHARS//\/[&.;]/}                        # Don't consider certain characters part of the word
PROMPT_EOL_MARK=''                                      # Removes the trailing % at the end of newlines
export SUDO_PROMPT=$'\e[38;2;207;34;46mPassword:\e[0m ' # Make the sudo prompt simpler and colorful

# Config for less
export LESS="-S -R -F --incsearch --mouse"

# Color man pages (with bat)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# EDITOR
export EDITOR=vim

# Prompt
eval "$(starship init bash)"

# Binds
bind -x '"\ep": fzpm'  # Esc + p for fzpm
bind -x '"\et": fztmx' # Esc + t for fztmx
bind -x '"\ef": vifm'  # Esc + f for vifm

fastfetch
