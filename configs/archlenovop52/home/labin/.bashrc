#  ███████████    █████████    █████████  █████   █████
# ░░███░░░░░███  ███░░░░░███  ███░░░░░███░░███   ░░███
#  ░███    ░███ ░███    ░███ ░███    ░░░  ░███    ░███
#  ░██████████  ░███████████ ░░█████████  ░███████████
#  ░███░░░░░███ ░███░░░░░███  ░░░░░░░░███ ░███░░░░░███
#  ░███    ░███ ░███    ░███  ███    ░███ ░███    ░███
#  ███████████  █████   █████░░█████████  █████   █████
# ░░░░░░░░░░░  ░░░░░   ░░░░░  ░░░░░░░░░  ░░░░░   ░░░░░

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#set -euo pipefail

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

# source all files in .bashrc.d directory
for file in $HOME/.bashrc.d/*.bashrc; do
    source $file
done

# Source fzf
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash

# When selecting files with fzf, we show file content with syntax highlighting,
# or without highlighting if it's not a source file. If the file is a directory,
# we use tree to show the directory's contents.
# We only load the first 200 lines of the file which enables fast previews
# of large text files.
# Requires highlight and tree: pacman -S highlight tree
export FZF_DEFAULT_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

# Color man pages (with bat)
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"

# Prompt
eval "$(starship init bash)"

# History settings
HISTFILE=~/.bash_history
HISTSIZE=1000
SAVEHIST=500
HISTCONTROL=ignoreboth:erasedups

# Other settings
WORDCHARS=${WORDCHARS//\/[&.;]/}            # Don't consider certain characters part of the word
PROMPT_EOL_MARK=''                          # Removes the trailing % at the end of newlines
export SUDO_PROMPT=$'\e[33mPassword:\e[0m ' # Make the sudo prompt simpler and colorful

# NVM - Node Version Manager
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec

# Config for less
export LESS="-SRXF"

# EDITOR variable
if command -v code &>/dev/null; then
    export EDITOR=code
else
    export EDITOR=nano
fi

if command -v tmux &>/dev/null && command -v tmux-runner &>/dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
    exec tmux-runner && exit
fi
