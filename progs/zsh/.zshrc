# =====================================================================
# THE COMPLETE GNU UTILITIES STACK (macOS & Linux)
# =====================================================================

case "$OSTYPE" in
    darwin*) # macOS Specific Configuration
        # Rely on $HOMEBREW_PREFIX set by .zprofile to avoid slow subshell calls
        if [[ -n "$HOMEBREW_PREFIX" ]]; then

            # 1. Custom Paths for Utilities Without 'gnubin' Subfolders
            export PATH="$HOMEBREW_PREFIX/opt/curl/bin:$PATH"
            export PATH="$HOMEBREW_PREFIX/opt/gnu-getopt/bin:$PATH"
            export PATH="$HOMEBREW_PREFIX/opt/jpeg/bin:$PATH"
            export PATH="$HOMEBREW_PREFIX/opt/binutils/bin:$PATH"

            # 2 & 3. Complete GNU Binaries & Manual Pages (Loop for cleaner code)
            local gnu_tools=(coreutils findutils gnu-sed gnu-tar gawk grep make diffutils ed gpatch wdiff)
            for tool in "${gnu_tools[@]}"; do
                export PATH="$HOMEBREW_PREFIX/opt/$tool/libexec/gnubin:$PATH"
                export MANPATH="$HOMEBREW_PREFIX/opt/$tool/libexec/gnuman:$MANPATH"
            done

            # 4. Mappings for Formulas Missing 'gnubin' Structures
            alias objdump='gobjdump'
            alias nm='gnm'
            alias size='gsize'
            alias strings='gstrings'
            alias ar='gar'
            alias ranlib='granlib'
            alias indent='gindent'
            alias which='gwhich'
        fi
        ;;

    linux*) # Linux Specific Configuration
        # Natively runs GNU tools out of the box. No manual overrides are required.
        ;;
esac

# =====================================================================
# VERIFICATION BLOCK
# =====================================================================
# Run `verify_all_gnu_tools` manually in the terminal to test your environment.
verify_all_gnu_tools() {
    echo "--- Complete GNU Environment Verification ---"

    if curl --version 2>&1 | grep -q "Features:"; then echo "✅ curl: Homebrew version active"; else echo "❌ curl: Native macOS active"; fi
    if getopt --version 2>&1 | grep -q "getopt"; then echo "✅ getopt: GNU gnu-getopt active"; else echo "❌ getopt: Native BSD active"; fi

    if command ls --version >/dev/null 2>&1; then echo "✅ coreutils (ls): GNU active"; else echo "❌ coreutils (ls): Native BSD active"; fi
    if find --version >/dev/null 2>&1; then echo "✅ findutils (find): GNU active"; else echo "❌ findutils (find): Native BSD active"; fi
    if sed --version >/dev/null 2>&1; then echo "✅ gnu-sed (sed): GNU active"; else echo "❌ gnu-sed (sed): Native BSD active"; fi
    if tar --version 2>&1 | grep -q "GNU"; then echo "✅ gnu-tar (tar): GNU active"; else echo "❌ gnu-tar (tar): Native BSD active"; fi
    if awk --version 2>&1 | grep -q "GNU"; then echo "✅ gawk (awk): GNU active"; else echo "❌ gawk (awk): Native BSD active"; fi
    if grep --version >/dev/null 2>&1; then echo "✅ grep (grep): GNU active"; else echo "❌ grep (grep): Native BSD active"; fi
    if make --version >/dev/null 2>&1; then echo "✅ make (make): GNU active"; else echo "❌ make (make): Native BSD active"; fi
    if diff --version 2>&1 | grep -q "GNU diffutils"; then echo "✅ diffutils (diff): GNU active"; else echo "❌ diffutils (diff): Native BSD active"; fi
    if gzip --version 2>&1 | grep -q "gzip"; then echo "✅ gzip (gzip): GNU active"; else echo "❌ gzip (gzip): Native BSD active"; fi

    if ed --version >/dev/null 2>&1; then echo "✅ ed (ed): GNU active"; else echo "❌ ed (ed): Native BSD active"; fi
    if patch --version 2>&1 | grep -q "GNU patch"; then echo "✅ gpatch (patch): GNU active"; else echo "❌ gpatch (patch): Native BSD active"; fi

    if objdump --version 2>&1 | grep -q "GNU"; then echo "✅ binutils (objdump): GNU active"; else echo "❌ binutils (objdump): Native BSD active"; fi
    if wdiff --version >/dev/null 2>&1; then echo "✅ wdiff (wdiff): GNU active"; else echo "❌ wdiff (wdiff): Not found / Inactive"; fi
    if indent --version 2>&1 | grep -q "GNU"; then echo "✅ gnu-indent (indent): GNU active"; else echo "❌ gnu-indent (indent): Native BSD active"; fi
    if which --version 2>&1 | grep -q "GNU"; then echo "✅ gnu-which (which): GNU active"; else echo "❌ gnu-which (which): Native BSD active"; fi

    echo "---------------------------------------------"
}

# =====================================================================
# CUSTOM ALIASES & MODERN CLI ALIAS OVERRIDES
# =====================================================================
alias cat='bat'
alias ls='eza -l'
alias la='eza -la'
alias tree='eza --tree'

# =====================================================================
# THIRD PARTY SHELL PLUGINS & PROMPT INITIALIZATION
# =====================================================================
if command -v fzf >/dev/null 2>&1; then
source <(fzf --zsh)
fi

if command -v starship >/dev/null 2>&1; then
eval "$(starship init zsh)"
fi