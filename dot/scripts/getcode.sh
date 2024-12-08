#!/bin/bash

# Function to check if a file is ignored by .gitignore or has certain extensions
is_ignored() {
    local file="$1"
    local extension="${file##*.}"

    # Check if the file is ignored by .gitignore
    git check-ignore -q "$file" 2>/dev/null && return 0

    # Ignore files with specific extensions (png, jpg, ico)
    case "$extension" in
        png|jpg|ico|jpeg|lockb) return 0 ;;
    esac

    return 1
}

# Function to process files and directories
process_directory() {
    local dir="$1"
    local indent="$2"

    # Loop through all files and directories in the given directory
    for item in "$dir"/*; do
        # Get the relative path
        local relative_path="${item#./}"

        if [ -f "$item" ] && ! is_ignored "$relative_path"; then
            echo "${indent}=== $relative_path ==="
            cat "$item"
            echo ""
        elif [ -d "$item" ] && ! is_ignored "$relative_path"; then
            echo "${indent}Directory: $relative_path"
            process_directory "$item" "  $indent"
        fi
    done
}

# Start processing from the current directory or a specified directory
process_directory "${1:-.}" ""
