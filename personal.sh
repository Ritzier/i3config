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
    check_packages bash zsh python-virtualenv alacritty i3 rofi polybar rofi  \
        polybar fcitx5-im fcitx5-chinese-addons pavucontrol pipewire-pulse \
        adobe-source-han-serif-cn-fonts wqy-zenhei noto-fonts-cjk \
        noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono-nerd \
        polybar fcitx5-im fcitx5-chinese-addons nautilus python-pip rofi \
        xdotool wmctrl maim unclutter pkgfile xsel xclip touchegg bc easyeffects \
        lsp-plugins calf firefox-tridactyl otf-comicshanns-nerd xorg xorg-server \
        rustup 

    alert_message "Installed all packages"
}

function dialog_neovim {
    path="$HOME/.config/nvim"
    REPOS_SSH="git@github.com:Ritzier/nvim"
    REPOS_HTTPS="https://github.com/ritzier/nvim"

    function clone_through_ssh {
        git clone $REPOS_SSH --depth=1 "$path"
    }

    function clone_through_https {
        git clone $REPOS_HTTPS --depth=1 "$path"
    }

    check_packages neovim rust-analyzer tree-sitter taplo rust-analyzer ripgrep \
        fd luarocks lua51

    dialog --title "Neovim" --menu "Choose an option:" 15 50 3 \
        1 "git@github.com:Ritzier/nvim" \
        2 "https://github.com/Ritzier/nvim" \
        3 "Exit" 2> neovim_choice.txt

    CHOICE=$(< neovim_choice.txt)

    case $CHOICE in
        1)
            clone_through_ssh
            ;;
        2)
            clone_through_https
            ;;
        *)
            return
            ;;
    esac

    alert_message "Neovim configuration done!"
}

function personal_menu {
    while true; do
        dialog --title "System" --menu "Choose an option:" 15 50 8 \
            1 "Basic Packages" \
            2 "i3" \
            3 "Alacritty" \
            4 "Zsh" \
            5 "Neovim" \
            6 "Fcitx5" \
            7 "EasyEffect" \
            8 "Exit" 2> personal_choice.txt

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
                dialog_neovim
                ;;
            6)
                dialog_fcitx7
                ;;
            7)
                dialog_easyeffect
                ;;
            8)
                break
                ;;
            *)
                break
                ;;
        esac
    done
    rm -f personal_choice.txt
}

