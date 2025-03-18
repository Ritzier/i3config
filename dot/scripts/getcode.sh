#!/bin/bash

main() {
    local dir="${1:-./}"

    # Ignore specific file extensions and .git directory
    local ignore_extensions=(-not \( -name "*.png" -o -name "*.mp4" -o \
        -name "*.mp3" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.ttf" \))

    # Check if directory is a Git repository
    local git_ignore=false
    if git -C "$dir" rev-parse 2>/dev/null; then
        git_ignore=true
    fi

    # Find and process files with .git exclusion
    find "$dir" \
        -name ".git" -prune -o \
        -type f "${ignore_extensions[@]}" -print0 | while IFS= read -r -d $'\0' file; do

        # Skip Git-ignored files if in repository
        if $git_ignore && git -C "$dir" check-ignore -q "$file"; then
            continue
        fi

        # Skip binary files based on MIME type
        if file -i "$file" | grep -q 'charset=binary'; then
            continue
        fi

        # Print file header and contents
        printf "=== %s ===" "$file"
        cat -- "$file"
    done
}

main "${1}"
