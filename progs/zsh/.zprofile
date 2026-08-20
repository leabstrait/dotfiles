export HOMEBREW_NO_ANALYTICS=1

# Initialize Homebrew environment dynamically based on architecture path
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv zsh)"
fi