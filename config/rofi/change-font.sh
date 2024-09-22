#!/bin/bash

# Define the two font choices
options=(
    "JetBrainsMono Nerd Font Mono"
)

# If no input is given (Rofi initial invocation), output the font options
if [ -z "$@" ]; then
    # Show the two font options in Rofi
    printf "%s\n" "${options[@]}"
else
    # If the user selected a font, use it to modify the Alacritty config file
    selected_font="$@"

    # Path to your Alacritty config file
    CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"

    # Replace the font family in the Alacritty config file
    sed -i "s/^normal.family = .*/normal.family = \"$selected_font\"/" "$CONFIG_FILE"
    sed -i "s/^bold.family = .*/bold.family = \"$selected_font\"/" "$CONFIG_FILE"
    sed -i "s/^italic.family = .*/italic.family = \"$selected_font\"/" "$CONFIG_FILE"
    sed -i "s/^bold_italic.family = .*/bold_italic.family = \"$selected_font\"/" "$CONFIG_FILE"

fi
