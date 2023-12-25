#  ███████████    █████████    █████████  █████   █████
# ░░███░░░░░███  ███░░░░░███  ███░░░░░███░░███   ░░███
#  ░███    ░███ ░███    ░███ ░███    ░░░  ░███    ░███
#  ░██████████  ░███████████ ░░█████████  ░███████████
#  ░███░░░░░███ ░███░░░░░███  ░░░░░░░░███ ░███░░░░░███
#  ░███    ░███ ░███    ░███  ███    ░███ ░███    ░███
#  ███████████  █████   █████░░█████████  █████   █████
# ░░░░░░░░░░░  ░░░░░   ░░░░░  ░░░░░░░░░  ░░░░░   ░░░░░

#set -euo pipefail

### Options ###
# setopt correct                                                  # Auto correct mistakes
# setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
# setopt nocaseglob                                               # Case insensitive globbing
# setopt rcexpandparam                                            # Array expension with parameters
# setopt nocheckjobs                                              # Don't warn about running processes when exiting
# setopt numericglobsort                                          # Sort filenames numerically when it makes sense
# setopt nobeep                                                   # No beep
# setopt appendhistory                                            # Immediately append history instead of overwriting
# setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
# setopt autocd                                                   # if only directory path is entered, cd there.

### source all files in .bashrc.d directory ###
for file in $HOME/.bashrc.d/*.bashrc; do
    source $file
done

### Source homegrown functions ###
source $HOME/dotfiles/dotfiles.sh
source $HOME/notes/notes.sh

### Source fzf ###
source /usr/share/fzf/completion.bash
source /usr/share/fzf/key-bindings.bash

# When selecting files with fzf, we show file content with syntax highlighting,
# or without highlighting if it's not a source file. If the file is a directory,
# we use tree to show the directory's contents.
# We only load the first 200 lines of the file which enables fast previews
# of large text files.
# Requires highlight and tree: pacman -S highlight tree
export FZF_DEFAULT_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

### Theming ###
# autoload -U compinit colors zcalc
# compinit -d
# colors

# Color man pages (with termcap variables)
export LESS_TERMCAP_mb=$'\E[05;31m'    # Start blink
export LESS_TERMCAP_md=$'\E[01;32m'    # Start bold
export LESS_TERMCAP_me=$'\E[0m'        # Turn off bold, blink and underline
export LESS_TERMCAP_se=$'\E[0m'        # Stop standout
export LESS_TERMCAP_so=$'\E[01;44;30m' # Start standout (reverse video)
export LESS_TERMCAP_ue=$'\E[0m'        # Stop underline
export LESS_TERMCAP_us=$'\E[04;33m'    # Start underline

export HISTCONTROL=ignoreboth:erasedups

### Prompt ###
eval "$(starship init bash)"

### Auto-completion ###
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
# zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
# zstyle ':completion:*' rehash true                              # Automatically find new executables in path

# Speed up completions
# zstyle ':completion:*' accept-exact '*(N)'
# zstyle ':completion:*' use-cache on
# zstyle ':completion:*' menu select
# zstyle ':completion:*' cache-path ~/.zsh/cache

# History settings
HISTFILE=~/.bash_history
HISTSIZE=1000
SAVEHIST=500

### Plugins ###
# # Use syntax highlighting
# source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# # Use history substring search
# source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
# source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# zmodload zsh/terminfo
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#aaaaee,bg=grey,bold,underline"

### Keybindings ###

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB:menu-complete'
# And Shift-Tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

# Display a list of the matching files
bind "set show-all-if-ambiguous on"

# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind "set menu-complete-display-prefix on"

# Cycle through history based on characters already typed on the line
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# Keep Ctrl-Left and Ctrl-Right working when the above are used
bind '"\e[1;5C":forward-word'
bind '"\e[1;5D":backward-word'

### Keybindings ###
# bindkey '^[[2~' overwrite-mode                                  # Insert -> Toggle insert mode
# bindkey '^[[3~' delete-char                                     # Delete -> Deletes the next character
# bindkey '^[[C'  forward-char                                    # → -> Go one character on the right
# bindkey '^[[D'  backward-char                                   # ← -> -- --- --------- -- --- left
# bindkey '^[[5~' history-beginning-search-backward               # ↑ -> Navigate up in the history
# bindkey '^[[6~' history-beginning-search-forward                # ↓ -> Navigate down in the history
# # Navigate words
# bindkey '^[[1;5C' forward-word                                  # Ctrl+→ -> Goto next word
# bindkey '^[[1;5D' backward-word                                 # Ctrl+← -> Goto previous word
# bindkey '^H' backward-kill-word                                 # Ctrl+backspace -> Delete previous word
# bindkey '^[[Z' undo                                             # Shift+tab -> Undo last action
# # History substring search
# bindkey "$terminfo[kcuu1]" history-substring-search-up          # ↑ -> Try to find a similar command up in the history
# bindkey '^[[A' history-substring-search-up                      # ↑ -> --- -- ---- - ------- ------- -- -- --- -------
# bindkey "$terminfo[kcud1]" history-substring-search-down        # ↓ -> --- -- ---- - ------- ------- down in the history
# bindkey '^[[B' history-substring-search-down                    # ↓ -> --- -- ---- - ------- ------- ---- -- --- -------

### Other settings ###
WORDCHARS=${WORDCHARS//\/[&.;]/}            # Don't consider certain characters part of the word
PROMPT_EOL_MARK=''                          # Removes the trailing % at the end of newlines
export SUDO_PROMPT=$'\e[33mPassword:\e[0m ' # Make the sudo prompt simpler and colorful

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

# Local bin path
export PATH="$HOME/.local/bin:$PATH"

# Funtions to load and unload env vars from an .env file
function loadenv() {
    [ "$#" -eq 1 ] && env="$1" || env="$PWD/.env"
    [ -f "$env" ] && { echo "Env file $(realpath $env) found - loading its env vars..."; } || { return 0; }
    set -o allexport
    source <(
        /usr/bin/cat "$env" |
            sed -e '/^#/d;/^\s*$/d' |
            sed -e "s/'/'\\\''/g" |
            sed -e "s/=\(.*\)/='\1'/g"
    ) && "$@"
    set +o allexport
    unset env
}
function unloadenv() {
    [ "$#" -eq 1 ] && oldenv="$1" || [ -f "$OLDPWD/.env" ] && oldenv="$OLDPWD/.env" || oldenv="$PWD/.env"
    [ -f "$oldenv" ] && { echo "Env file $(realpath $oldenv) found - remove its env vars..."; } || { return 0; }
    unset $(grep -v '^#' $oldenv | sed -E 's/(.*)=.*/\1/' | xargs)
    unset oldenv
}
# Run unloadenv(old dir) and loadenv(new dir) on every new directory
function cd() {
    builtin cd $@
    unloadenv
    loadenv
}
