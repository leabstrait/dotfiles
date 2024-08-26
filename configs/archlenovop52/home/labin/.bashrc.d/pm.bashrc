# Package manager

# alias to generate and save mirrorlist for pacman
alias pmrefresh='sudo reflector --country 'GB,DE' --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# Command not found, suggest package
source /usr/share/doc/pkgfile/command-not-found.bash

# Bind fuzzy package manager command
bind -x '"\ep": fzpm' # Esc + p for fuzzy package manager
