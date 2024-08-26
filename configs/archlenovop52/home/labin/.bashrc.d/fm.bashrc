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

# Key bindings
bind -x '"\ef": vifm' # Esc + f to open vifm
