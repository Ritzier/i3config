#!/bin/bash

source ./system.sh
source ./personal.sh

function start_menu {
    # dialog --yesno "Do you want to quit?"
    while true; do
        dialog --title "Main Menu" --menu "Choose an option:" 15 50 3 \
            1 "System" \
            2 "Personal" \
            3 "Exit" 2> main_choice.txt

        MAIN_CHOICE=$(< main_choice.txt)

        case $MAIN_CHOICE in
            1)
                system_menu
                ;;
            2)
                personal_menu
                ;;
            3)
                break
                ;;
        esac
    done
    rm -f main_choice.txt
}


start_menu
