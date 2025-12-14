function alert_message() {
    dialog --msgbox "$1" 5 30
}

function check_empty_variable() {
    for var in "$@"; do
        eval "value=\$$var"
        if [[ -z "$value" ]]; then
            dialog --title "Error" --msgbox "$var is empty" 10 40
            return 1
        fi
    done
    return 0
}


function check_packages() {
    # Initialize an array to hold missing packages
    local missing_packages=()

    # Iterate over all given package names
    for package in "$@"; do
        # Check if the package is installed using pacman
        if ! pacman -Q "$package" &>/dev/null; then
            # Add missing package to the list
            missing_packages+=("$package")
        fi
    done

    # If there are missing packages, install them using sudo pacman
    if [[ ${#missing_packages[@]} -gt 0 ]]; then
        echo "Installing missing packages: ${missing_packages[*]}"
        # Use --needed to avoid reinstalling already installed packages and wait for completion
        sudo pacman -S --needed --noconfirm "${missing_packages[@]}" && \
            dialog --title "Success" --msgbox "The following packages were installed: ${missing_packages[*]}" 10 50
    fi
}
