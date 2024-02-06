### Alias ###

# basic navgation and file management
alias ls='eza -lh --color=always --group-directories-first --icons'
alias ll="ls -l"           # Ls with a lot of file information such as permissions
alias la="ls -a"           # Normal ls but hidden files are listed too
alias lsd="ls -ld *(-/DN)" # Ls with folders / symlinks only
alias cp="cp -riv"         # Copy    (recursive, verbose, interactive)
alias mkdir='mkdir -vp'    # Makedir (verbose, parents)
alias mv="mv -iv"          # Move    (recursive, verbose, interactive))
alias rm="rm -riv"         # Remove  (recursive, verbose, interactive)
alias tree="eza --tree"
alias fcd="cd ~ && cd \$(find * -type d | fzf)"

alias rs="rsync -r --info=progress2" # Rsync with progress bar

# # crypto
# alias gpg="gpg -c --no-symkey-cache --cipher-algo AES256" # Encrypt with AES256

# editor
alias v="vim"          # Shorter editor command
alias sv="sudo -E vim" # Edit file as root with nano
alias cat="bat --theme=ansi"

# utils
alias df="df -h"                                  # Human-readable sizes
alias free="free -m"                              # Show sizes in MB
alias topdisk="du -a . | sort -n -r | head -n 10" # show top 10 large files/dirs

# package manager
# alias to generate and save mirrorlist for pacman
alias pmrefresh='sudo reflector --country 'GB,DE' --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# sql clients
alias psql="pgcli"
alias mysql="mycli"
