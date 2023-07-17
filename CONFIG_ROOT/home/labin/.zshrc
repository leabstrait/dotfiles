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
alias ls='exa -l --color=always --group-directories-first --icons'
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
alias n="nano"                                                  # Shorter editor command
alias sn="sudo -E nano"                                         # Edit file as root with nano
alias cat="bat --theme=ansi"

# utils
alias df="df -h"                                                # Human-readable sizes
alias free="free -m"                                            # Show sizes in MB

# package manager
# alias to generate and save mirrorlist for pacman
alias pmrefresh='sudo reflector --country 'GB,DE' --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'


# sql clients
alias psql="pgcli"
alias mysql="mycli"


### Functions ###

## Manage dotfiles with the dotfiles function
function dotfiles() {
    DOTFILES_DIR="$HOME/dotfiles"
    # check if the function is provided with arguments
    if [ $# -eq 0 ]; then
        echo "Usage: dotfiles ( <command> <file> | <git commands> )"
        echo "<command>: track, untrack, backup"
        echo "<file>: the file to track or untrack"
        echo "<git commands>: git commands to be executed"
        echo ""
        echo "Example: dotfiles track .zshrc"
        echo "Example: dotfiles untrack .zshrc"
        echo "Example: dotfiles commit -m ''"
        return
    fi

    # check if the first argument is a valid command (track, untrack, sync) or a git command
    if [ "$1" = "track" ] || [ "$1" = "untrack" ] || [ "$1" = "listchanges" ] ; then

        local command=$1
        echo "command: $command"

        # resolve the file
        if [ ! -z "$2" ]; then
            if [ -f "$2" ]; then
                local file=$(realpath "$2")
                echo "file: $file"
            else
                echo "File not found: $2"
                return
            fi
        else
            echo "No file provided"
        fi



        if [ $command = "track" ]; then
            # check if the file path is prefixed with the dotfiles directory
            if [[ ! $file =~ ^$DOTFILES_DIR ]]; then
                mkdir -p $DOTFILES_DIR/CONFIG_ROOT$(dirname $file)
                cp $file $DOTFILES_DIR/CONFIG_ROOT$file
                # create a symlink to the dotfiles directory
                # if file is not in home directory, require sudo access
                if [ $file = ${file#"$HOME"} ]; then
                    # sudo mv $file $DOTFILES_DIR/CONFIG_ROOT$file.bak
                    sudo ln -sfv $DOTFILES_DIR/CONFIG_ROOT$file $file
                else
                    # mv $file $DOTFILES_DIR/CONFIG_ROOT$file.bak
                    ln -sfv $DOTFILES_DIR/CONFIG_ROOT$file $file
                fi
            else
                echo "File $file is already tracked in the dotfiles directory"
            fi
        fi

        if [ $command = "untrack" ]; then
            local tracked_file_orig_path=${file#"$DOTFILES_DIR/CONFIG_ROOT"}
            if [ -L $tracked_file_orig_path ]; then
                # move the file from the dotfiles directory into the original
                # directory preserving its path and name (if it exists)
                # require sudo access if the file is not in the home directory
                if [ $tracked_file_orig_path = ${tracked_file_orig_path#"$HOME"} ]; then
                    sudo mv $file $tracked_file_orig_path
                else
                    mv $file $tracked_file_orig_path
                fi
            else
                echo "File $file is not tracked yet or does not exist"
            fi
        fi

        if [ $command = "listchanges" ]; then
            find $DOTFILES_DIR/CONFIG_ROOT -type f  | while read tracked_file ; do
                if [ -f $tracked_file ]; then
                    local tracked_file_orig_path=${tracked_file#"$DOTFILES_DIR/CONFIG_ROOT"}
                    if [ ! -L $tracked_file_orig_path ]; then
                        echo "tracked_file: $tracked_file"
                        echo "tracked_file_orig_path: $tracked_file_orig_path"
                        # ask the user if we should show diff between the tracked file and the original file
                        echo "Do you want to show the diff between the tracked file and the original file? (y/n)"
                        read REPLY < /dev/tty
                        echo
                        if [[ $REPLY =~ ^[Yy]$ ]]; then
                            echo "diff:"
                            if [ $tracked_file_orig_path = ${tracked_file_orig_path#"$HOME"} ]; then
                                # echo  $tracked_file_orig_path $tracked_file | xargs code -dw -
                                echo  $tracked_file_orig_path $tracked_file | xargs sudo meld
                                echo "Do you want to overwrite the original file with the tracked file? (y/n)"
                                read REPLY < /dev/tty
                                if [[ $REPLY =~ ^[Yy]$ ]]; then
                                    sudo ln -sfv $tracked_file $tracked_file_orig_path
                                fi
                                echo
                            else
                                # echo $tracked_file_orig_path $tracked_file |xargs  code -dw -
                                echo $tracked_file_orig_path $tracked_file |xargs  meld
                                echo "Do you want to overwrite the original file with the tracked file? (y/n)"
                                read REPLY < /dev/tty
                                if [[ $REPLY =~ ^[Yy]$ ]]; then
                                     ln -sfv $tracked_file $tracked_file_orig_path
                                fi
                                echo
                            fi
                        fi
                    fi
                fi
            done
        fi

    else
        if [ -d "$DOTFILES_DIR/.git"  ]; then
            git --git-dir=$DOTFILES_DIR/.git --work-tree=$DOTFILES_DIR $@
        fi
    fi
}


## Functions to load and unload environment variables from an .env file
# Load variable specified in .env file into the current shell
function loadenv() {
    set -o allexport
        [ "$#" -eq 1 ] && env="$1" || env=".env"
        [ -f "$env" ] && { echo "Env file $env exists, Sourcing..."; } || { return 1; }
        source <(cat "$env" \
            | sed -e '/^#/d;/^\s*$/d' \
            | sed -e "s/'/'\\\''/g" \
            | sed -e "s/=\(.*\)/='\1'/g" \
        ) && "$@"
    set +o allexport
}

# Run loadenv on shell start
# loadenv
# Run loadenv on every new directory
cd () {
  builtin cd $@
  loadenv
}

# Unset variables specified in the .env if it exists
function unloadenv() {
    if [ -f .env ];
    then
        unset $(grep -v '^#' .env | sed -E 's/(.*)=.*/\1/' | xargs)
    fi
}


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
#autoload -U promptinit; promptinit
#prompt spaceship                                                # Install it from the AUR (spaceship-prompt-git)
##spaceship_vi_mode_disable                                       # Pretty explicit
#SPACESHIP_EXEC_TIME_SHOW=true                                   # Enable showing the execution time of last command
#SPACESHIP_DIR_TRUNC=1
#setopt prompt_subst                                             # Enable substitution for prompt

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

## Powerline
#powerline-daemon -q
#source /usr/share/powerline/bindings/zsh/powerline.zsh
