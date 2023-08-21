## Manage dotfiles with the dotfiles function
function dotfiles() {
    DOTFILES_DIR="$HOME/dotfiles"

    if [ ! -f "$DOTFILES_DIR/CONFIG_ROOT" ]; then
        echo "Need the CONFIG_ROOT file!"
        return
    fi


    CONFIG_ROOT="$HOME/dotfiles/configs/$(cat "$DOTFILES_DIR/CONFIG_ROOT")"
    echo $CONFIG_ROOT

    # check if the function is provided with arguments
    if [ $# -eq 0 ]; then
        echo "Usage: dotfiles ( <command> <file> | <git commands> )"
        echo "<command>: track, untrack, backup"
        echo "<file>: the file to track or untrack"
        echo "<git commands>: git commands to be executed"
        echo ""
        echo "Example: dotfiles track .zshrc"
        echo "Example: dotfiles untrack .zshrc"
        echo "Example: dotfiles commit -m ''"
        return
    fi

    # check if the first argument is a valid command (track, untrack, sync) or a git command
    if [ "$1" = "track" ] || [ "$1" = "untrack" ] || [ "$1" = "listchanges" ]; then

        local command=$1
        echo "command: $command"

        # resolve the file
        if [ ! -z "$2" ]; then
            if [ -f "$2" ]; then
                local file=$(realpath "$2")
                echo "file: $file"
            else
                echo "File not found: $2"
                return
            fi
        else
            echo "No file provided"
        fi

        if [ $command = "track" ]; then
            # check if the file path is prefixed with the dotfiles directory
            if [[ ! $file =~ ^$DOTFILES_DIR ]]; then
                mkdir -p $CONFIG_ROOT$(dirname $file)
                cp $file $CONFIG_ROOT$file
                # create a symlink to the dotfiles directory
                # if file is not in home directory, require sudo access
                if [ $file = ${file#"$HOME"} ]; then
                    # sudo mv $file $DOTFILES_DIR/CONFIG_ROOT$file.bak
                    sudo ln -sfv $CONFIG_ROOT$file $file
                else
                    # mv $file $DOTFILES_DIR/CONFIG_ROOT$file.bak
                    ln -sfv $CONFIG_ROOT$file $file
                fi
            else
                echo "File $file is already tracked in the dotfiles directory"
            fi
        fi

        if [ $command = "untrack" ]; then
            local tracked_file_orig_path=${file#"$CONFIG_ROOT"}
            if [ -L $tracked_file_orig_path ]; then
                # move the file from the dotfiles directory into the original
                # directory preserving its path and name (if it exists)
                # require sudo access if the file is not in the home directory
                if [ $tracked_file_orig_path = ${tracked_file_orig_path#"$HOME"} ]; then
                    sudo mv $file $tracked_file_orig_path
                else
                    mv $file $tracked_file_orig_path
                fi
            else
                echo "File $file is not tracked yet or does not exist"
            fi
        fi

        if [ $command = "listchanges" ]; then
            find $DOTFILES_DIR/CONFIG_ROOT -type f | while read tracked_file; do
                if [ -f $tracked_file ]; then
                    local tracked_file_orig_path=${tracked_file#"$DOTFILES_DIR/CONFIG_ROOT"}
                    if [ ! -L $tracked_file_orig_path ]; then
                        echo "tracked_file: $tracked_file"
                        echo "tracked_file_orig_path: $tracked_file_orig_path"
                        # ask the user if we should show diff between the tracked file and the original file
                        echo "Do you want to show the diff between the tracked file and the original file? (y/n)"
                        read REPLY </dev/tty
                        echo
                        if [[ $REPLY =~ ^[Yy]$ ]]; then
                            echo "diff:"
                            if [ $tracked_file_orig_path = ${tracked_file_orig_path#"$HOME"} ]; then
                                # echo  $tracked_file_orig_path $tracked_file | xargs code -dw -
                                echo $tracked_file_orig_path $tracked_file | xargs sudo meld
                                echo "Do you want to overwrite the original file with the tracked file? (y/n)"
                                read REPLY </dev/tty
                                if [[ $REPLY =~ ^[Yy]$ ]]; then
                                    sudo ln -sfv $tracked_file $tracked_file_orig_path
                                fi
                                echo
                            else
                                # echo $tracked_file_orig_path $tracked_file |xargs  code -dw -
                                echo $tracked_file_orig_path $tracked_file | xargs meld
                                echo "Do you want to overwrite the original file with the tracked file? (y/n)"
                                read REPLY </dev/tty
                                if [[ $REPLY =~ ^[Yy]$ ]]; then
                                    ln -sfv $tracked_file $tracked_file_orig_path
                                fi
                                echo
                            fi
                        fi
                    fi
                fi
            done
        fi

    else
        if [ -d "$DOTFILES_DIR/.git" ]; then
            git --git-dir=$DOTFILES_DIR/.git --work-tree=$DOTFILES_DIR $@
        fi
    fi
}
