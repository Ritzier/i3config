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
    missing_packages=()
    for package in "$@"; do
        if ! pacman -Q "$package" &>/dev/null; then
            missing_packages+=("$package")
        fi
    done

    if [[ ${#missing_packages[@]} -ne 0 ]]; then
        sudo pacman -S --needed "${missing_packages[@]}"
    fi
}
