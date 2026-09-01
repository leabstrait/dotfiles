# =====================================================================
# ~/.bashrc - Shell Configuration (Arch Linux Only)
# =====================================================================

# Exit if any command fails, if an unset variable is used, or if a pipeline fails
#set -euo pipefail

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ---------------------------------------------------------------------
# 1. PATH CONFIGURATION & TOOLCHAIN SETUP
# ---------------------------------------------------------------------
export PATH="~/.local/bin:$PATH"

# ---------------------------------------------------------------------
# 2. EDITOR, PAGER & FORMATTING ENVIRONMENT
# ---------------------------------------------------------------------
export EDITOR='emacs'
export VISUAL='emacs'
export PAGER='less'
export MANPAGER='less -R'
export MANROFFOPT='-P -c'

export WORDCHARS="${WORDCHARS//[&.;]/}"
export SUDO_PROMPT=$'\e[38;2;207;34;46mPassword:\e[0m '

# Less UI Colors & Configurations
export LESS_MINT=$'\e[38;5;43m'
export LESS_BLUE=$'\e[38;5;33m'
export LESS_RESET=$'\e[0m'
export LESS='-S -R -F --incsearch --mouse --use-color -Dd33.16 -Du33.16 -Ds43.16 -DP43.16 -DR33.16 -DE43.16 -DS43.16'
export LESS_TERMCAP_md="${LESS_MINT}"
export LESS_TERMCAP_me="${LESS_RESET}"
export LESS_TERMCAP_us="${LESS_BLUE}"
export LESS_TERMCAP_ue="${LESS_RESET}"
export LESS_TERMCAP_so=$'\e[48;5;43;30m'
export LESS_TERMCAP_se="${LESS_RESET}"

# ---------------------------------------------------------------------
# 3. HISTORY & SHELL BEHAVIOR OPTIONS (SHOPT)
# ---------------------------------------------------------------------
export HISTFILE=~/.bash_history
export HISTSIZE=1000
export SAVEHIST=500
export HISTCONTROL=ignoreboth:erasedups

shopt -s autocd
shopt -s checkwinsize
shopt -s cdspell
shopt -s histappend
shopt -s cmdhist
shopt -s extglob
shopt -s no_empty_cmd_completion

# ---------------------------------------------------------------------
# 4. FILE MANAGEMENT & NAVIGATION ALIASES
# ---------------------------------------------------------------------
alias cat='bat'
alias ls='eza -h --color=always --group-directories-first --icons=always'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias tree='eza --tree'

alias cp='cp -riv'
alias mkdir='mkdir -vp'
alias mv='mv -iv'
alias rm='rm -riv'
alias rs='rsync -r --info=progress2'

alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias df='df -h'
alias free='free -m'
alias topdisk='du -a . | sort -n -r | head -n 10'
alias ip='ip -color=auto'

# ---------------------------------------------------------------------
# 5. SYSTEM UTILITIES & PACKAGE MANAGEMENT
# ---------------------------------------------------------------------
export DIFFPROG='emacs -nw'
alias pmrefresh='sudo reflector --age 24 --protocol https --sort rate --save /etc/pacman.d/mirrorlist'

# ---------------------------------------------------------------------
# 6. FUNCTIONS & BINDINGS
# ---------------------------------------------------------------------
function run-help() {
   local COMMAND
   COMMAND=$(echo "$READLINE_LINE" | sed 's/^[ \t]*//;s/[ \t]*$//')
   help "$COMMAND" || man "$COMMAND" || bash -c "${COMMAND} --help"
}
bind -x '"\eh": run-help'

# ---------------------------------------------------------------------
# 7. THIRD-PARTY TOOLS & INTEGRATIONS
# ---------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --bash)"
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

if [ -f /usr/share/doc/pkgfile/command-not-found.bash ]; then
    source /usr/share/doc/pkgfile/command-not-found.bash
fi

if [[ -z "${SSH_CONNECTION}" ]]; then
   export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi
