# Funtions to load and unload env vars from an .env file
# Automatically loads environment variables when changing directories.

# Function to load environment variables from a .env file
function loadenv() {
    [ "$#" -eq 1 ] && env="$1" || env="$PWD/.env"
    [ -f "$env" ] && { echo "Env file $(realpath $env) found - loading its env vars..."; } || { return 0; }
    set -o allexport
    source <(
        <"$env" |
            sed -e '/^#/d;/^\s*$/d' |
            sed -e "s/'/'\\\''/g" |
            sed -e "s/=\(.*\)/='\1'/g"
    ) && "$@"
    set +o allexport
    unset env
}

# Function to unload environment variables
function unloadenv() {
    [ "$#" -eq 1 ] && oldenv="$1" || [ -f "$OLDPWD/.env" ] && oldenv="$OLDPWD/.env" || oldenv="$PWD/.env"
    [ -f "$oldenv" ] && { echo "Env file $(realpath $oldenv) found - remove its env vars..."; } || { return 0; }
    unset $(grep -v '^#' $oldenv | sed -E 's/(.*)=.*/\1/' | xargs)
    unset oldenv
}

# Run unloadenv(old dir) and loadenv(new dir) on every new directory
function cd() {
    builtin cd $@
    unloadenv
    loadenv
}
