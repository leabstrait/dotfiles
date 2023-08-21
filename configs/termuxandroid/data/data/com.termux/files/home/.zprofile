export EDITOR=vi

# Config for less
export LESS="-SRXF"

# Local bin path
export PATH="$PATH:$HOME/.local/bin"

# swap Esc and Caps
# setxkbmap -option caps:ctrl_modifier

# Export explicitly installed packages
pkg list-installed 2> /dev/null | sed -E 's=/.*|Listing.*==' > linux-packages.list 

