#!/bin/bash

setup_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh/" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    echo "Copying zshrc configuration"
    cp ./dot/zshrc $HOME/.zshrc
}

install_packages() {
    sudo pacman -S $@
    # echo ${packages}
}

python_virtualenv() {
    if [ ! -d "${1}" ]; then
        python -m venv $1
        echo "Setup python virtualenv successful"
    else
        echo "Python Virtualenv already setup"
    fi
    echo "Don't forget to source Python Virtualenv in the .zshrc"
}

oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "Oh-My-Zsh Installed Successfully"
    else
        echo "Oh-My-Zsh Installed"
    fi
}

zsh_theme() {
    zsh_theme_file=$HOME/.oh-my-zsh/themes/ritz.zsh-theme
    if [ ! -f $zsh_theme_file ]; then
        git clone https://github.com/Ritzier/ritz.zsh-theme --depth=1 ./theme
        cp theme/ritz.zsh-theme $zsh_theme_file
        rm -rf ./theme
        echo "Installed Zsh Theme successfully"
    else
        echo "Zsh Theme Already Installed"
    fi
}

setup_fcitx() {
    if [ ! -d $HOME/.local/share/fcitx5/themes ]; then
        git clone https://github.com/catppuccin/fcitx5.git
        mkdir -p ~/.local/share/fcitx5/themes/
        cp -r ./fcitx5/src/* ~/.local/share/fcitx5/themes
        rm -rf fcitx5
        echo "Fcitx5 Theme Setup Successfully"
    else
        echo "Fcitx5 Theme Already Setup"
    fi
}

copy_configuration() {
    cp -r ./config/* $HOME/.config/*
}

setup_touchegg() {
    if [ ! -f $HOME/.config/touchegg/touchegg.conf ]; then
        cp -r /usr/share/touchegg $HOME/.config/
        sudo systemctl enable touchegg
    fi
}

setup_pkgfile() {
    sudo pkgfile -u
}

run() {
    setup_oh_my_zsh
    install_packages bash zsh python-virtualenv alacritty i3 rofi polybar fcitx5-im fcitx5-chinese-addons pavucontrol pipewire-pulse adobe-source-han-serif-cn-fonts wqy-zenhei noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono-nerd alacritty polybar fcitx5-im fcitx5-chinese-addons nautilus python-pip rofi xdotool wmctrl maim unclutter pkgfile xsel xclip touchegg bc easyeffects lsp-plugins calf
    python_virtualenv $HOME/python312/
    oh_my_zsh
    zsh_theme
    setup_fcitx
    copy_configuration
    setup_touchegg
    setup_pkgfile
    echo "Done"
}

run
