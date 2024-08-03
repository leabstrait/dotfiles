# Source fzf
eval "$(fzf --bash)"

# fzf options
export FZF_DEFAULT_OPTS="
    --multi
    --padding 1%
    --border sharp
    --border-label '╢ fuzzy finder ╟'
    --border-label-pos '-5'
    --preview-window 'border-sharp'
    --info inline-right:'matched (sel) '
    --prompt '▶ '
    --pointer '→ '
    --marker 'λ '
    --layout reverse
    --bind '?:toggle-preview'
    --bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'
    --header 'fzf

CTRL-c or ESC: quit
CTRL-Y: copy selection into clipboard
?: toggle preview (if available)

'
    --header-first
    --color bg+:#e6e6e6,fg:#383a42,fg+:#50a050,border:#383a42,spinner:#383a42,hl:#c28402,header:#0070d4,info:#50a050,pointer:#e4564a,marker:#0070d4,prompt:#383a42,hl+:#e4564a
"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --preview-window 'down:3:hidden:wrap'
"

export FZF_ALT_C_OPTS="
    --preview 'eza --color=always --tree {}'
"

export FZF_CTRL_T_OPTS="
    --preview '(bat --color=always {} || eza --color=always --tree {}) 2> /dev/null'
"

# fzf and paru
fzpm() {
    selection=$(
        paru -Qq | fzf \
            --multi \
            --preview='cat <(paru -Qi {1}) <(paru -Ql {1} | awk "{print \$2}")' \
            --prompt 'querypkgs ▶ ' \
            --bind 'del:execute-silent(tmux display-popup -E "paru -Rcnsuv {+}")' \
            --bind 'enter:execute-silent(tmux display-popup -E "paru -S {+}")' \
            --bind 'ctrl-s:change-prompt(syncpkgs ▶ )' \
            --bind 'ctrl-s:+reload(paru -Slq)' \
            --bind 'ctrl-s:+change-preview(cat <(paru -Si {1}) <(paru -Fl {1} | awk "{print \$2}"))' \
            --bind 'ctrl-s:+refresh-preview' \
            --bind 'ctrl-q:change-prompt(querypkgs ▶ )' \
            --bind 'ctrl-q:+reload(paru -Qq)' \
            --bind 'ctrl-q:+change-preview(cat <(paru -Qi {1}) <(paru -Ql {1} | awk "{print \$2}"))' \
            --bind 'ctrl-q:+refresh-preview' \
            --bind 'ctrl-a:select-all' \
            --bind 'ctrl-x:deselect-all' \
            --header 'fuzzy package manager

Ctrl-s: switch to sync mode
Ctrl-q: switch to query mode
Ctrl-a: select all | Ctrl-x: deselect all
Enter: (re)install selected packages
Del: remove selected packages

'
    )
}
