#!/bin/bash

main() {
    local dir="${1:-./}"

    # Check if directory is a Git repository
    local git_ignore=false
    if git -C "$dir" rev-parse 2>/dev/null; then
        git_ignore=true
    fi

    echo "File struct"
    tree "${dir}"
    echo ""

    # Use fd to find files, excluding specific extensions and .git directory
    fd --type f \
        --exclude "*.png" \
        --exclude "*.mp4" \
        --exclude "*.mp3" \
        --exclude "*.jpg" \
        --exclude "*.jpeg" \
        --exclude "*.ttf" \
        --exclude ".git" \
        --print0 \
        . "$dir" | while IFS= read -r -d $'\0' file; do

        # Skip Git-ignored files if in repository
        if $git_ignore && git -C "$dir" check-ignore -q "$file" 2>/dev/null; then
            continue
        fi

        # Skip binary files based on MIME type
        if file -i "$file" 2>/dev/null | grep -q 'charset=binary'; then
            continue
        fi

        # Print file header and contents
        echo ""
        printf "=== %s ===\n" "$file"
        cat -- "$file"
    done
}

main "${1}"
