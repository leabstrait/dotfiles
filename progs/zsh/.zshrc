# =====================================================================
# .zshrc - Unified Shell Configuration (macOS & Arch Linux)
# =====================================================================

[[ $- != *i* ]] && return

# ---------------------------------------------------------------------
# 1. PATH CONFIGURATION & TOOLCHAIN SETUP
# ---------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# case "$(uname -s)" in
#     Darwin) # macOS Homebrew GNU Toolchain Overrides
#         if [[ -n "$HOMEBREW_PREFIX" ]]; then
#             export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
#             export PATH="$HOMEBREW_PREFIX/opt/gnu-getopt/bin:$PATH"
#             export PATH="$HOMEBREW_PREFIX/opt/jpeg/bin:$PATH"
#             export PATH="$HOMEBREW_PREFIX/opt/binutils/bin:$PATH"
#             export PATH="$HOMEBREW_PREFIX/opt/gnu-indent/bin:$PATH"
#             export PATH="$HOMEBREW_PREFIX/opt/gnu-which/bin:$PATH"

#             local gnu_tools=(coreutils findutils gnu-sed gnu-tar gawk grep make diffutils ed gpatch wdiff gnu-indent gnu-which)
#             for tool in "${gnu_tools[@]}"; do
#                 export PATH="$HOMEBREW_PREFIX/opt/$tool/libexec/gnubin:$PATH"
#                 export MANPATH="$HOMEBREW_PREFIX/opt/$tool/libexec/gnuman:$MANPATH"
#             done

#             alias objdump='gobjdump'
#             alias nm='gnm'
#             alias size='gsize'
#             alias strings='gstrings'
#             alias ar='gar'
#             alias ranlib='granlib'
#             alias indent='gindent'
#             alias which='gwhich'
#         fi
#         ;;
#     Linux)
#         # Arch Linux uses native standard toolchain paths
#         ;;
# esac

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
# 3. HISTORY & SHELL BEHAVIOR OPTIONS
# ---------------------------------------------------------------------
export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=500
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# ---------------------------------------------------------------------
# 4. FILE MANAGEMENT & NAVIGATION ALIASES
# ---------------------------------------------------------------------
alias cat='bat'
alias ls='eza -lh --color=always --group-directories-first --icons=always'
alias ll='ls -l'
alias la='ls -la'
alias lsd='ls -ld *(-/DN)'
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
# 6. THIRD-PARTY TOOLS & INTEGRATIONS
# ---------------------------------------------------------------------
if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
fi

if command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

if [[ -z "${SSH_CONNECTION}" ]]; then
   export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
fi