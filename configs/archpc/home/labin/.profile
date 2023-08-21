export EDITOR=code
export TERMINAL=alacritty
export QT_QPA_PLATFORMTHEME="qt5ct"
export QT_AUTO_SCREEN_SCALE_FACTOR=0
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=/usr/bin/google-chrome-stable

# Config for less
export LESS="-SRXF"

# Local bin path
export PATH="$PATH:$HOME/.local/bin"

# swap Esc and Caps
# setxkbmap -option caps:ctrl_modifier

# Export vscode extensions
code --list-extensions >$HOME/dotfiles/vscode-extensions.list

# Export explicitly installed packages
# pacman -Qqte >$HOME/dotfiles/linux-packages.list
paru -Qqt >$HOME/dotfiles/linux-packages.list

# Ibus autostart
export XIM=ibus
export XIM_PROGRAM=/usr/bin/ibus-daemon
export XIM_ARGS="--xim"
export XMODIFIERS=@im=ibus
export GTK_IM_MODULE="ibus"
export QT_IM_MODULE="ibus"
export DefaultIMModule=ibus
ibus-daemon -drxR

# Android Studio
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
PATH=$PATH:$ANDROID_SDK_ROOT/tools
PATH=$PATH:$ANDROID_SDK_ROOT/platform-tools
