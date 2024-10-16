#!/bin/bash

# Get all font include "Nerd Font"
# Store the output in an array
mapfile -t NERD_FONTS < <(fc-list --format="%{family[0]}\n" | sort | uniq | grep -E "Nerd Font")

# Change `normal`, `bold`, `italic`, `bold_italic` to `$1`
alacritty_fonts()
{
    CONFIG_FILE="$HOME/.config/alacritty/alacritty.toml"
    SELECTED_FONT="${1}"

    sed -i "s/^normal.family = .*/normal.family = \"$SELECTED_FONT\"/" "$CONFIG_FILE"
    sed -i "s/^bold.family = .*/bold.family = \"$SELECTED_FONT\"/" "$CONFIG_FILE"
    sed -i "s/^italic.family = .*/italic.family = \"$SELECTED_FONT\"/" "$CONFIG_FILE"
    sed -i "s/^bold_italic.family = .*/bold_italic.family = \"$SELECTED_FONT\"/" "$CONFIG_FILE"
}

# Rofi script
select_theme()
{
    local MORE_FLAGS=(-dmenu)
    local CUR="default"
    declare -i SELECTED
    while true
    do
        declare -i RTS
        declare -i RES
        # RES=$(echo "$nerd_fonts" | rofi -dmenu -format i -i -p "Select a Nerd Font" -cycle -selected_row "${SELECTED}")
        RES=$(printf "%s\n" "${NERD_FONTS[@]}" | rofi -dmenu -format i -i -p "Select a Nerd Font" -cycle -selected-row "${SELECTED}")
        RTR=$?

        if [ "${RTR}" = 10 ]
        then
            return 0
        elif [ "${RTR}" = 1 ] || [ "${RTR}" = 65 ] # user pressed escape or no selection
        then
            return 1
        fi

        SELECTED=${RES}
        alacritty_fonts "${NERD_FONTS[${RES}]}"
    done
}

# select_theme()

select_theme
