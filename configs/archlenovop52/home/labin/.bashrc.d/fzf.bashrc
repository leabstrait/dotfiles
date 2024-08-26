# fzf - the fuzzy finder

# Source fzf
eval "$(fzf --bash)"

# fzf options
export FZF_DEFAULT_OPTS="
    --padding 1%
    --border sharp
    --separator="─"
    --scrollbar="║"
    --border-label '╢ fuzzy finder ╟'
    --border-label-pos '-5'
    --preview-window 'border-sharp'
    --info inline-right:'matched (sel) '
    --prompt '▶ '
    --pointer ' ⟹'
    --marker '● '
    --layout reverse
    --bind '?:toggle-preview'
    --bind 'ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)'
    --bind 'change:top'
    --header-first
    --header 'fzf

CTRL-c or ESC: quit
CTRL-Y: copy selection into clipboard
?: toggle preview (if available)

'
"

# colors (GitHub Light)
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
    --color bg:-1,fg:-1
    --color preview-bg:-1,preview-fg:-1
    --color bg+:-1,fg+:#0969da
    --color header:#1b7c83
    --color label:#1b7c83
    --color border:#6e7781,preview-border:#6e7781
    --color scrollbar:#1b7c83,preview-scrollbar:#1b7c83
    --color pointer:#0969da,marker:#0969da,spinner:#1b7c83
    --color prompt:#0969da,info:#1b7c83
    --color hl:#a40e26,hl+:#cf222e
    --color separator:#6e7781
"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}'
    --preview-window 'down:3:hidden:wrap'
    --height 70%
"

export FZF_ALT_C_OPTS="
    --preview 'eza --color=always --tree {}'
    --height 70%
"

export FZF_CTRL_T_OPTS="
    --preview '(bat --color=always {} || eza --color=always --tree {}) 2> /dev/null'
    --height 70%
"

