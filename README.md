# i3config

`cfdisk`
`mkfs`: `mkfs.fat -F32`, `mkfs.ext4 /dev/nvme0n1p1`
`pacstrap`
`genfstab`
`chroot`

## Basic package

`linux`, `linux-headers`, `linux-firmware`, `base`, `base-devel`, `vim`, `git`,
`i3`, `intel-ucode`, `xorg`, `network-manager`, `efibootmgr`, `pavucontrol`,
`pipewire-pulse`, ``

```sh
pacman -S linux linux-headers linux-firmware base base-devel vim git i3 intel-ucode xorg networkmanager  efibootmgr pavucontrol pipewire-pulse ly dhcpcd adobe-source-han-serif-cn-fonts wqy-zenhei noto-fonts-cjk noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono-nerd alacritty polybar fcitx5-im fcitx5-chinese-addons nautilus rustup go composer luarocks tree-sitter neovim python-virtualenv python-pip chromium rofi bluez bluez-utils bluez-obex libinput xdotool wmctrl maim unclutter openssh wireless-regdb docker docker-compose pkgfile
```

## Efibootmgr

```sh
efibootmgr --create \
--disk /dev/sda --part 1 \
--label "Arch EFI" \
--loader /vmlinuz-linux \
--unicode 'root=UUID=b2978444-769b-4d1b-8061-c1ac685e5fc7 rw loglevel=3 quiet splash reboot=bios initrd=\initramfs-linux.img'
```

use `blkid` just output uuid of specific partition or get the UUID from
`/etc/fstab`:

```sh
blkid -s UUID -o value /dev/nvme0n1p1
```

## System configuration

- `passwd`
- `sudoers`
- systemctl: `NetworkManager`, `dhcpcd`
- Modified `locale.gen` and `locale.conf`, run `locale-gen`
- `openssh`, `keygen`
- Modified `/etc/hostname`, and `/etc/hosts`:

```
127.0.0.1   localhost
::1         localhost
127.0.1.1   hostname
```

- `rustup`

### Reflector

update pacman mirroslist

```sh
reflector --verbose --ipv4 --sort rate --score 10 --save /etc/pacman.d/mirrorlist
```

### Timedatectl

```sh
timedatectl set-ntp true
timedatectl set-timezone <time_zone>
```

Can check the timezone with `tiemdatectl list-timezones`

### Swap

```
mkswap -U clear --size 4G --file /swapfile
swapon /swapfile
```

`/etc/fstab`:

```
/swapfile none swap defaults 0 0
```

### Pkgfile

Sync `pkgfile` database

```sh
sudo pkgfile -u
```

### i3 (Xorg) and display manager

Install dependencies:

```sh
pacman -S i3 xorg ly
```

enable display manager:

```sh
systemctl enable ly
```

### GPU Driver

Install graphic driver:

- Intel graphics: `xf86-video-intel` and `mesa`
- Nvidia graphics: Turing serias or newer `nvidia-open` else `nvidia`

### Optimus Manager

```sh
pacman -S optimus-manager
systemctl enable optimus-manager
```

Need add `prime-offload` to configuration:

```sh
exec --no-startup-id prime-offload
```

Can check the optimus-manager status:

```sh
optimus-manager --status
```

### Fcitx5

```sh
pacman -S fcitx5-im fcitx5-chinese-addons
```

`/etc/environment`:

```sh
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

### Docker

- systemctl
- `usermod -aG docker $USER`

### Bluetooth

```sh
sudo pacman -S bluez bluez-utils bluez-obex
sudo systemctl enable --now bluetooth
```

### Touchpad

`/etc/X11/xorg.conf.d/30-touchpad.conf`:

```sh
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
EndSection
```

require `libinput-gestures` (AUR) add user to group input

```sh
sudo gpasswd -a $USER input
```

Could check configuration file in `config/libinput-gestures.conf`

Start it:

```sh
libinput-gestures-setup autostart
```

### Wifi

Dependencies: `wireless-regdb`,`dnsmasq`, `iptables`, `wpa_supplicant`,
`dhcpcd`, `firewalld`, `linux-wifi-hotspot`

#### Enable 5Ghz

Modified `/etc/conf.d/wireless-regdom`, uncomment it:

Reboot it, and check country code with: `iw reg get`

Show the band with: `iw list | grep -A 15 Frequencies:`

#### Hotspot

Require: `linux-wifi-hotspot`

`systemctl enable create_ap` for startup

example `/etc/create_ap.conf`:

```sh
CHANNEL=default
GATEWAY=192.168.1.1
WPA_VERSION=2
ETC_HOSTS=0
DHCP_DNS=gateway
NO_DNS=0
NO_DNSMASQ=0
HIDDEN=0
MAC_FILTER=0
MAC_FILTER_ACCEPT=/etc/hostapd/hostapd.accept
ISOLATE_CLIENTS=0
SHARE_METHOD=nat
IEEE80211N=0
IEEE80211AC=0
IEEE80211AX=1
HT_CAPAB=[HT40+]
VHT_CAPAB=
DRIVER=nl80211
NO_VIRT=0
COUNTRY=
FREQ_BAND=5
NEW_MACADDR=
DAEMONIZE=0
DAEMON_PIDFILE=
DAEMON_LOGFILE=/dev/null
DNS_LOGFILE=
NO_HAVEGED=0
WIFI_IFACE=wlp41s0
INTERNET_IFACE=enp48s0f3u1
SSID=Hotspot
PASSPHRASE=12345678
USE_PSK=0
ADDN_HOSTS=
```

## Other

### Python venv

```sh
python -m venv $HOME/python312
pip install neovim
```
