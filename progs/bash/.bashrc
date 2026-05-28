# Exit if any command fails, if an unset variable is used, or if a pipeline fails
# set -euo pipefail

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH configuration
export PATH="$HOME/.local/bin:$PATH"

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

# History settings
export HISTFILE=~/.bash_history
export HISTSIZE=1000
export SAVEHIST=500
export HISTCONTROL=ignoreboth:erasedups


# File management and navigation

# Enhanced directory listing
alias ls='eza -lh --color=always --group-directories-first --icons'
alias ll='ls -l'           # Detailed listing with permissions
alias la='ls -a'           # Listing including hidden files
alias lsd='ls -ld *(-/DN)' # List only directories and symlinks

# File operations
alias cp='cp -riv'      # Copy files (recursive, verbose, interactive)
alias mkdir='mkdir -vp' # Create directories (verbose, parents)
alias mv='mv -iv'       # Move files (recursive, verbose, interactive)
alias rm='rm -riv'      # Remove files (recursive, verbose, interactive)

# Directory tree
alias tree='eza --tree' # Show directory tree

# Synchronization
alias rs='rsync -r --info=progress2' # Rsync with progress bar


# Editors, viewers, and related functions

# Edit environment settings
export WORDCHARS=${WORDCHARS//\/[&.;]/} # Exclude certain characters from word boundaries
export PROMPT_EOL_MARK=''               # Remove the trailing % at the end of newlines

# Less configuration
export LESS="-S -R -F --incsearch --mouse --use-color -Dd+30 -Du+33 -Ds+99 -DP255.29 -DR255.29 -DE255.160 -DS255.33"
export PAGER="less"

# Colorize man pages with less
export MANPAGER="less"
export MANROFFOPT="-P -c"

# EDITOR variable
export EDITOR="code --wait"

# Function to run help or man page
function run-help() {
	COMMAND=$(echo "$READLINE_LINE" | sed 's/^[ \t]*//;s/[ \t]*$//')
echo "sdf${COMMAND}sdfs"
   help "$COMMAND" || man "$COMMAND"  || bash -c "${COMMAND} --help"
#man "$COMMAND"
}
bind -m vi-insert -x '"\eh": run-help' # Alt + h for help or manpage

# Use bat instead of cat
alias cat="bat"

# diff with color
alias diff="diff --color=auto"

# grep with color
alias grep="grep --color=auto"


# direnv
eval "$(direnv hook bash)"


# NVM - Node Version Manager

source /usr/share/nvm/init-nvm.sh

# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


# Package manager

# alias to generate and save mirrorlist for pacman
alias pmrefresh='sudo reflector --country AU,DE --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# Command not found, suggest package
source /usr/share/doc/pkgfile/command-not-found.bash


# SSH
if [[ -z "${SSH_CONNECTION}" ]]; then
   export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
   # ssh-add ~/.ssh/id_ed25519
fi

# system utils

alias df="df -h"                                  # Human-readable sizes
alias free="free -m"                              # Show sizes in MB
alias topdisk="du -a . | sort -n -r | head -n 10" # show top 10 large files/dirs
alias ip='ip -color=auto'                         # Colorize ip output
