#!/bin/bash

source ./components.sh

function dialog_i3 {
    check_packages i3 polybar rofi ttf-jetbrains-mono-nerd
    cp -rf ./config/i3 ./config/rofi ./config/polybar "$HOME"/.config/

    alert_message "i3 configuration done!"
}

function dialog_alacritty {
    check_packages alacritty otf-comicshanns-nerd
    cp -rf ./config/alacritty/ "$HOME"/.config/
    alert_message "Alacritty configuration done"
}

function dialog_zsh {
    check_packages zsh

    if ! [[ -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    cp ./dot/zshrc "$HOME/.zshrc"

    if ! [[ -f "$HOME/.oh-my-zsh/themes/ritz.zsh-theme" ]]; then
        git clone https://github.com/ritzier/ritz.zsh-theme theme
        cp theme/ritz.zsh-theme "$HOME/.oh-my-zsh/themes"
    fi

    if [[ -d ./theme ]]; then
        rm -rf ./theme
    fi

    alert_message "Zsh configuration done!"
}

# For Fcitx5 colorscheme
function dialog_fcitx5 {
    git clone https://github.com/catppuccin/fcitx5.git
    mkdir -p ~/.local/share/fcitx5/themes/
    cp -r ./fcitx5/src/* ~/.local/share/fcitx5/themes
    rm -rf fcitx5
    alert_message "Fcitx5 configuration done!"
}

function dialog_easyeffect {
    check_packages easyeffects
    cp -rf ./config/easyeffects "$HOME/.config/"
    alert_message "Easyeffect configuration done!"
}

function dialog_basic_packages {
    check_packages bash zsh python-virtualenv alacrity i3 rofi polybar rofi  \
        polybar fcitx5-im fcitx5-chinese-addons pavucontrol pipewire-pulse \
        adobe-source-han-serif-cn-fonts wqy-zenhei noto-fonts-cjk \
        noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono-nerd \
        polybar fcitx5-im fcitx5-chinese-addons nautilus python-pip rofi \
        xdotool wmctrl maim unclutter pkgfile xsel xclip touchegg bc easyeffects \
        lsp-plugins calf firefox-tridactyl otf-comicshanns-nerd

    alert_message "Installed all packages"
}

function personal_menu {
    while true; do
        dialog --title "System" --menu "Choose an option:" 15 50 7 \
            1 "Basic Packages" \
            2 "i3" \
            3 "Alacritty" \
            4 "Zsh" \
            5 "Fcitx5" \
            6 "EasyEffect" \
            7 "Exit" 2> personal_choice.txt

        SYSTEM_CHOICE=$(< personal_choice.txt)

        case $SYSTEM_CHOICE in
            1)
                dialog_basic_packages
                ;;
            2)
                dialog_i3
                ;;
            3)
                dialog_alacritty
                ;;
            4)
                dialog_zsh
                ;;
            5)
                dialog_fcitx6
                ;;
            6)
                dialog_easyeffect
                ;;
            7)
                break
                ;;
            *)
                break
                ;;
        esac
    done
    rm -f personal_choice.txt
}

