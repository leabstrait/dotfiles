# Exit if any command fails, if an unset variable is used, or if a pipeline fails
#set -euo pipefail

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
alias ll='ls -l'           						# Detailed listing with permissions
alias la='ls -a'           						# Listing including hidden files
alias lsd='ls -ld *(-/DN)' 						# List only directories and symlinks

# File operations
alias cp='cp -riv'       						# Copy files (recursive, verbose, interactive)
alias mkdir='mkdir -vp' 						# Create directories (verbose, parents)
alias mv='mv -iv'       						# Move files (recursive, verbose, interactive)
alias rm='rm -riv'      						# Remove files (recursive, verbose, interactive)

# Directory tree
alias tree='eza --tree' 						# Show directory tree

# Synchronization
alias rs='rsync -r --info=progress2' 					# Rsync with progress bar


# Editors, viewers, and related functions

# Shell editing / environment settings
export WORDCHARS=${WORDCHARS//\/[&.;]/}     # Exclude certain characters from word boundaries
export PROMPT_EOL_MARK=''                   # Remove the trailing % at end of newlines

# Colors
export LESS_MINT=$'\e[38;5;43m'             # Accent: ~ #6ae4b9
export LESS_BLUE=$'\e[38;5;33m'             # Secondary blue
export LESS_RESET=$'\e[0m'

# Less configuration
export LESS='-S -R -F --incsearch --mouse --use-color -Dd33.16 -Du33.16 -Ds43.16 -DP43.16 -DR33.16 -DE43.16 -DS43.16'

# Man / groff formatting colors
export LESS_TERMCAP_md="${LESS_MINT}"       # Bold: headings, names, options
export LESS_TERMCAP_me="${LESS_RESET}"

export LESS_TERMCAP_us="${LESS_BLUE}"       # Underline: references
export LESS_TERMCAP_ue="${LESS_RESET}"

export LESS_TERMCAP_so=$'\e[48;5;43;30m'     # Search / standout: mint background
export LESS_TERMCAP_se="${LESS_RESET}"

# Keep ANSI colors in man pages
export MANPAGER='less -R'
export MANROFFOPT='-P -c'

# Pager
export PAGER='less'

# Editors
export EDITOR='emacs'
export VISUAL='emacs'

# Pager
export PAGER='less'

# Function to run help or man page
function run-help() {
   COMMAND=$(echo "$READLINE_LINE" | sed 's/^[ \t]*//;s/[ \t]*$//')
   help "$COMMAND" || man "$COMMAND"  || bash -c "${COMMAND} --help"
}
bind  -x '"\eh": run-help' # Alt + h for help or manpage

# Use bat instead of cat
alias cat='bat'
export BAT_THEME='ansi'

# diff with color
alias diff='diff --color=auto'

# grep with color
alias grep='grep --color=auto'

# Package manager

# alias to generate and save mirrorlist for pacman
alias pmrefresh='sudo reflector --country AU,DE --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'


# Command not found, suggest package
source /usr/share/doc/pkgfile/command-not-found.bash


# SSH
if [[ -z "${SSH_CONNECTION}" ]]; then
   export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
   ssh-add ~/.ssh/id_ed25519
fi

# system utils

alias df='df -h'                                  # Human-readable sizes
alias free='free -m'                              # Show sizes in MB
alias topdisk='du -a . | sort -n -r | head -n 10' # show top 10 large files/dirs
alias ip='ip -color=auto'                         # Colorize ip output

# fzf
eval "$(fzf --bash)"
