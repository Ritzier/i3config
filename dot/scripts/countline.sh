
#!/bin/bash

# Directory to search
directory="$1"

# Initialize a total line count variable
total_lines=0

# Iterate over each file in the directory
for file in "$directory"/*; do
    # Check if it's a regular file
    if [ -f "$file" ]; then
        # Count the number of lines in the file
        line_count=$(wc -l < "$file")
        # Add to the total line count
        total_lines=$((total_lines + line_count))
    fi
done

# Output the total line count
echo "Total lines in all files: $total_lines"
