#!/bin/bash

main() {
    local dir="./"
    local ignore_test=false # ./getcode.sh --ignore-test
    local ignore_patterns=()
    local dir_arg_set=

    # Argument Parsing
    # Loop through all arguments to find flags and the directory path.
    while [[ $# -gt 0 ]]; do
        case "$1" in
        --ignore-test)
            ignore_test=true
            shift
            ;;
        --ignore)
            if [[ -n "$2" ]]; then
                ignore_patterns+=("$2")
                shift 2
            else
                echo "Error: --ignore flag requires a pattern argument."
                exit 1
            fi
            ;;
        --)
            shift
            break
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            if [[ -z "$dir_arg_set" ]]; then
                dir="$1"
                dir_arg_set=true
            fi
            shift
            ;;
        esac
    done

    # Check if the target directory exists
    if [ ! -d "$dir" ]; then
        echo "Error: Directory '$dir' not found."
        exit 1
    fi

    # Check if directory is a Git repository
    local git_ignore=false
    if git -C "$dir" rev-parse 2>/dev/null; then
        git_ignore=true
    fi

    echo "File struct"
    tree "$dir" --gitignore
    echo ""

    # `fd` pattern args
    fd_args=(
        --type f
        --exclude "*.png"
        --exclude "*.mp4"
        --exclude "*.mp3"
        --exclude "*.jpg"
        --exclude "*.jpeg"
        --exclude "*.ttf"
        --exclude ".git"
    )

    # Add additional --exclude from --ignore arugments
    for pattern in "${ignore_patterns[@]}"; do
        fd_args+=(--exclude "$pattern")
    done

    # Use fd to find files, excluding specific extensions and .git directory
    fd "${fd_args[@]}" --print0 . "$dir" | while IFS= read -r -d $'\0' file; do

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
        # If --ignore-test is used and file is a Rust file, filter out test blocks
        if [[ "$ignore_test" == true && "$file" == *.rs ]]; then
            # Use awk to parse the Rust file and exclude #[cfg(test)] blocks.
            # This works by tracking the state:
            # - When it sees #[cfg(test)], it enters a "skip" state.
            # - It then finds the associated code block (e.g., mod, fn) and
            #   counts the opening and closing braces '{' '}' to find where the block ends.
            # - Once the brace count returns to zero, it resumes printing lines.
            awk '
            /^#\[cfg\(test\)\]/ {
                in_test_region = 1; # Found the attribute, start looking for the block
                next;
            }
            in_test_region && !in_test_block {
                # We are between the attribute and the start of the block.
                # Any line here (like the fn/mod definition) should be skipped.
                if (match($0, /{/)) {
                    in_test_block = 1;
                    # Count braces on the current line to handle single-line blocks
                    brace_level = gsub(/{/, "{") - gsub(/}/, "}");
                    if (brace_level <= 0) {
                        # The block ended on the same line it started
                        in_test_region = 0;
                        in_test_block = 0;
                    }
                }
                next;
            }
            in_test_block {
                # We are inside the test block, counting braces
                brace_level += gsub(/{/, "{") - gsub(/}/, "}");
                if (brace_level <= 0) {
                    # The block has ended
                    in_test_region = 0;
                    in_test_block = 0;
                }
                next;
            }
            { print } # Print any line that is not being skipped
            ' "$file"
        else
            # Default behavior: print the entire file
            cat -- "$file"
        fi
    done
}

main "$@"
