export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"


alias cat='bat'
alias ls='eza -l'
alias la='eza -la'
alias tree='eza --tree'

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
eval "$(starship init zsh)"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
