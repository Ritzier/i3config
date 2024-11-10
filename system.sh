#!/bin/bash

source ./components.sh

function dialog_efibootmgr {
    exec 3>&1

    root_device=$(lsblk -no PKNAME "$(findmnt -n -o SOURCE /)")
    full_root_device="/dev/$root_device"

    root_uuid=$(findmnt -n -o UUID /)

    dialog --separate-widget $'\n' \
        --title "EFI Boot Entry" \
        --form "" 0 0 0 \
        "Disk:" 1 1 "$full_root_device" 1 10 30 0 \
        "Partition:" 2 1 "1" 2 10 30 0 \
        "Label:" 3 1 "Arch EFI" 3 10 30 0 \
        "Root UUID:" 4 1 "$root_uuid" 4 10 30 0 \
        2>&1 1>&3 | {
        read -r disk
        read -r part
        read -r label
        read -r uuid

        check_empty_variable disk part label uuid

        # Call efibootmgr with the provided inputs
        efibootmgr --create \
            --disk "$disk" --part "$part" \
            --label "$label" \
            --loader /vmlinuz-linux \
            --unicode "root=UUID=\"$uuid\" rw loglevel=3 quiet splash initrd=\\initramfs-linux.img"

    }

    alert_message "EFI boot entry created successful!"

    exec 3>&-
}

function dialog_swap {
    exec 3>&1

    dialog --separate-widget $'\n' \
        --title "Create Swap" \
        --form "" 0 0 0 \
        "Path:" 1 1 "/swapfile" 1 10 30 0 \
        "Size:" 2 1 "4G" 2 10 30 0 \
        2>&1 1>&3 | {
        read -r path
        read -r size

        check_empty_variable path size

        mkswap -U clear --size "$size" --file "$path"

        if ! grep -q "$path" /etc/fstab; then
            echo "$path           	none      	swap      	defaults  	0 0"
        fi

        alert_message "Swap created successful"
    }

    exec 3>&-
}

function dialog_hostname {
    exec 3>&1

    name="$(cat /etc/hostname)"

    dialog --separate-widget $'\n' \
        --title "hostname" \
        --form "" 0 0 0 \
        "Name:" 1 1 "$name" 1 10 30 0 \
        2>&1 1>&3 | {
        read -r na

        echo "$na"

        check_empty_variable na

        if ! grep -q "127.0.0.1" "localhost"; then
            echo "127.0.0.1 localhost" >> /etc/hosts
        fi

        if ! grep -q "::1" "localhost"; then
            echo "::1 localhost" >> /etc/hosts
        fi

        if ! grep -q "127.0.1.1" "$na"; then
            echo "127.0.1.1 $na" >> /etc/hosts
        fi
    }

    alert_message "Hostname and Hosts done!"

    exec 3>&-
}

function dialog_mirrorlist {
    curl -s "https://archlinux.org/mirrorlist/?country=SG&protocol=https&ip_version=4" | sed 's/^#Server/Server/' > /etc/pacman.d/mirrorlist
    alert_message "Mirrorlist updated"
}

function dialog_fcitx5_setup {
    check_packages fcitx5 fcitx5-configtool fcitx5-chinese-addons

    env_file="/etc/environment"

    vars=(
        "GTK_IM_MODULE=fcitx"
        "QT_IM_MODULE=fcitx"
        "XMODIFIERS=@im=fcitx"
        "SDL_IM_MODULE=fcitx"
    )

    for var in "${vars[@]}"; do
        if ! grep -q "^$var" "$env_file"; then
            echo "$var" >> "$env_file"
        fi
    done


    alert_message "Fcitx5 configuration done!"
}

function dialog_wireless_regdb {
    check_packages wireless_regdb

    if grep -q "^#WIRELESS_REGDOM=\"US\"" /etc/conf.d/wireless-regdom; then
        sudo sed -i 's/^#WIRELESS_REGDOM="US"/WIRELESS_REGDOM="US"/' /etc/conf.d/wireless-regdom
    fi

    alert_message "Wireless-regdb configuration done!"
}


function dialog_optimus_manager {
    check_packages optimus-manager

    if ! [ -f /etc/optimus-manager/optimus-manager.conf ]; then
        cp /usr/share/optimus-manager/optimus-manager.conf /etc/optimus-manager/optimus-manager.conf
    fi

    alert_message "Optimus-manager configuration done!"
}

function dialog_gamecompatibility {
    env_file=/etc/sysctl.d/80-gamecompatibility.conf

    vars=(
        "vm.max_map_count = 2147483642"
    )

    for var in "${vars[@]}"; do
        if ! grep -q "^$var" "$env_file"; then
            echo "$var" >> "$env_file"
        fi
    done

    alert_message "Game compatibility done!"
}

function dialog_network {
    env_file=/etc/sysctl.d/70-network.conf

    vars=(
        "net.core.rmem_default = 1048576"
        "net.core.rmem_max = 16777216"
        "net.core.wmem_default = 1048576"
        "net.core.wmem_max = 16777216"
        "net.core.optmem_max = 65536"
        "net.ipv4.tcp_rmem = 4096 1048576 2097152"
        "net.ipv4.tcp_wmem = 4096 65536 16777216"
        "net.ipv4.udp_rmem_min = 8192"
        "net.ipv4.udp_wmem_min = 8192"
        "net.ipv4.tcp_fastopen = 3"
        "net.ipv4.tcp_max_syn_backlog = 8192"
        "net.ipv4.tcp_max_tw_buckets = 2000000"
        "net.ipv4.tcp_tw_reuse = 1"
        "net.ipv4.tcp_fin_timeout = 10"
        "net.ipv4.tcp_slow_start_after_idle = 0"
        "net.ipv4.tcp_keepalive_time = 60"
        "net.ipv4.tcp_keepalive_intvl = 10"
        "net.ipv4.tcp_keepalive_probes = 6"
        "net.ipv4.tcp_mtu_probing = 1"
        "net.ipv4.tcp_timestamps = 0"
        "net.ipv4.tcp_sack = 1"
        "net.core.default_qdisc = cake"
        "net.ipv4.tcp_congestion_control = bbr"
        "net.ipv4.tcp_syncookies = 1"
        "net.ipv4.conf.all.accept_redirects = 0"
        "net.ipv4.conf.default.accept_redirects = 0"
        "net.ipv4.conf.all.secure_redirects = 0"
        "net.ipv4.conf.default.secure_redirects = 0"
        "net.ipv6.conf.all.accept_redirects = 0"
        "net.ipv6.conf.default.accept_redirects = 0"
        "net.ipv4.conf.all.send_redirects = 0"
        "net.ipv4.conf.default.send_redirects = 0"
        "net.ipv4.icmp_echo_ignore_all = 1"
        "net.ipv6.icmp.echo_ignore_all = 1"
    )

    for var in "${vars[@]}"; do
        if ! grep -q "^$var" "$env_file"; then
            echo "$var" >> "$env_file"
        fi
    done

    alert_message "Network configuration done!"
}

function dialog_libinput {
    check_packages libinput

    cp ./etc/X11/xorg.config.d/40-touchpad.conf /etc/X11/xorg.conf.d/40-touchpad.conf

    alert_message "Libinput configuration done!"
}

function dialog_bluetooth {
    check_packages bluez bluez-util

    systemctl enable bluetooth

    alert_message "Bluetooth configuration done!"
}

function system_menu {
    if [[ $EUID -ne 0 ]]; then
        dialog --title "Permission Required" --msgbox "You need root privileges to create an EFI boot enty." 10 50
        return 1
    fi

    while true; do
        dialog --title "System" --menu "Choose an option:" 15 50 12 \
            1 "Efibootmgr" \
            2 "Create Swap" \
            3 "Set hostname" \
            4 "Mirrorlist" \
            5 "Fcitx Setup" \
            6 "Wireless Regdb" \
            7 "Optimus Manager" \
            8 "Game Compatibility" \
            9 "Network" \
            10 "Libinput" \
            11 "Bluetooth" \
            12 "Exit" 2> system_choice.txt

        SYSTEM_CHOICE=$(< system_choice.txt)

        case $SYSTEM_CHOICE in
            1)
                dialog_efibootmgr
                ;;
            2)
                dialog_swap
                ;;
            3)
                dialog_hostname
                ;;
            4)
                dialog_mirrorlist
                ;;
            5)
                dialog_fcitx6_setup
                ;;
            6)
                dialog_wireless_regdb
                ;;
            7)
                dialog_optimus_manager
                ;;
            8)
                dialog_gamecompatibility
                ;;
            9)
                dialog_network
                ;;
            10)
                dialog_libinput
                ;;
            11)
                dialog_bluetooth
                ;;
            12)
                break
                ;;
            *)
                break
                ;;
        esac
    done
    rm -f system_choice.txt
}
