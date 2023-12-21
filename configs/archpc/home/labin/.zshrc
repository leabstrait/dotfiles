#
# ███████╗███████╗██╗  ██╗
# ╚══███╔╝██╔════╝██║  ██║
#   ███╔╝ ███████╗███████║
#  ███╔╝  ╚════██║██╔══██║
# ███████╗███████║██║  ██║
# ╚══════╝╚══════╝╚═╝  ╚═╝
#

#set -euo pipefail

### Options ###
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.

### Alias ###

# basic navgation and file management
alias ls='eza -lh --color=always --group-directories-first --icons'
alias ll="ls -l"                                                # Ls with a lot of file information such as permissions
alias la="ls -a"                                                # Normal ls but hidden files are listed too
alias lsd="ls -ld *(-/DN)"                                      # Ls with folders / symlinks only
alias cp="cp -riv"                                              # Copy    (recursive, verbose, interactive)
alias mkdir='mkdir -vp'                                         # Makedir (verbose, parents)
alias mv="mv -iv"                                               # Move    (recursive, verbose, interactive))
alias rm="rm -riv"                                              # Remove  (recursive, verbose, interactive)

alias rs="rsync -r --info=progress2"                            # Rsync with progress bar

# crypto
alias gpg="gpg -c --no-symkey-cache --cipher-algo AES256"       # Encrypt with AES256

# editor
alias v="vim"                                                  # Shorter editor command
alias sv="sudo -E vim"                                         # Edit file as root with nano
alias cat="bat --theme=ansi"

# utils
alias df="df -h"                                                # Human-readable sizes
alias free="free -m"                                            # Show sizes in MB
alias topdisk="du -a . | sort -n -r | head -n 10"		            # show top 10 large files/dirs

# package manager
# alias to generate and save mirrorlist for pacman
alias pmrefresh='sudo reflector --country 'GB,DE' --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'


# sql clients
alias psql="pgcli"
alias mysql="mycli"


### Source homegrown functions ###
source $HOME/dotfiles/dotfiles.sh
source $HOME/notes/notes.sh

### Theming ###
autoload -U compinit colors zcalc
compinit -d
colors
# Color man pages (with termcap variables)
export LESS_TERMCAP_mb=$'\E[05;31m'                             # Start blink
export LESS_TERMCAP_md=$'\E[01;32m'                             # Start bold
export LESS_TERMCAP_me=$'\E[0m'                                 # Turn off bold, blink and underline
export LESS_TERMCAP_se=$'\E[0m'                                 # Stop standout
export LESS_TERMCAP_so=$'\E[01;44;30m'                          # Start standout (reverse video)
export LESS_TERMCAP_ue=$'\E[0m'                                 # Stop underline
export LESS_TERMCAP_us=$'\E[04;33m'                             # Start underline

export HISTCONTROL=ignoreboth:erasedups

### Prompt ###
eval "$(starship init zsh)"


### Auto-completion ###
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # Automatically find new executables in path
# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' menu select
zstyle ':completion:*' cache-path ~/.zsh/cache
# History settings
HISTFILE=~/.zhistory
HISTSIZE=1000
SAVEHIST=500

### Plugins ###
# Use syntax highlighting
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# Use history substring search
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
zmodload zsh/terminfo
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#aaaaee,bg=grey,bold,underline"

### Keybindings ###
bindkey '^[[2~' overwrite-mode                                  # Insert -> Toggle insert mode
bindkey '^[[3~' delete-char                                     # Delete -> Deletes the next character
bindkey '^[[C'  forward-char                                    # → -> Go one character on the right
bindkey '^[[D'  backward-char                                   # ← -> -- --- --------- -- --- left
bindkey '^[[5~' history-beginning-search-backward               # ↑ -> Navigate up in the history
bindkey '^[[6~' history-beginning-search-forward                # ↓ -> Navigate down in the history
# Navigate words
bindkey '^[[1;5C' forward-word                                  # Ctrl+→ -> Goto next word
bindkey '^[[1;5D' backward-word                                 # Ctrl+← -> Goto previous word
bindkey '^H' backward-kill-word                                 # Ctrl+backspace -> Delete previous word
bindkey '^[[Z' undo                                             # Shift+tab -> Undo last action
# History substring search
bindkey "$terminfo[kcuu1]" history-substring-search-up          # ↑ -> Try to find a similar command up in the history
bindkey '^[[A' history-substring-search-up                      # ↑ -> --- -- ---- - ------- ------- -- -- --- -------
bindkey "$terminfo[kcud1]" history-substring-search-down        # ↓ -> --- -- ---- - ------- ------- down in the history
bindkey '^[[B' history-substring-search-down                    # ↓ -> --- -- ---- - ------- ------- ---- -- --- -------

### Other settings ###
WORDCHARS=${WORDCHARS//\/[&.;]}                                 # Don't consider certain characters part of the word
PROMPT_EOL_MARK=''                                              # Removes the trailing % at the end of newlines
export SUDO_PROMPT=$'\e[33mPassword:\e[0m '                     # Make the sudo prompt simpler and colorful

### NVM - Node Version Manager ###
[ -z "$NVM_DIR" ] && export NVM_DIR="$HOME/.nvm"
source /usr/share/nvm/nvm.sh
source /usr/share/nvm/bash_completion
source /usr/share/nvm/install-nvm-exec

# Config for less
export LESS="-SRXF"

## Powerline
#powerline-daemon -q
#source /usr/share/powerline/bindings/zsh/powerline.zsh
