
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
    else
        dialog --msgbox "All packages are already installed." 10 50
    fi
}

function dialog_bluetooth() {
    # Ensure required Bluetooth packages are installed
    check_packages bluez bluez-utils

    # Enable Bluetooth service using systemctl and wait for completion
    echo "Enabling Bluetooth service..."
    sudo systemctl enable bluetooth && sudo systemctl start bluetooth

    # Display success message using dialog
    dialog --title "Success" --msgbox "Bluetooth configuration is complete!" 10 50
}

dialog_bluetooth
