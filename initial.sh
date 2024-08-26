#!/bin/bash

set_timedatectl() {
    timedatectl set-ntp true
    timedatectl set-timezone Asia/Singapore
}

set_locale() {
    sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
    grep -q '^LANG=' /etc/locale.conf || sh -c "echo LANG=en_US.UTF-8 >> /etc/locale.conf"
}

set_hostname() {
    [ -s /etc/hostname ] || sh -c "echo $1 > /etc/hostname"
}

set_hosts() {
    [ -s /etc/hosts ] || sh -c "echo '127.0.0.1 localhost
::1 localhost
127.0.1.1 $1' > /etc/hosts"
}

set_host() {
    set_hostname $1
    set_hosts $1
}

set_timedatectl
set_host "linux"
