# i3config

`cfdisk`
`mkfs`: `mkfs.fat -F32`, `mkfs.ext4 /dev/nvme0n1p1`
`pacstrap`
`genfstab`
`arch-chroot`

## Basic package

```sh
pacman -S linux linux-headers linux-firmware base base-devel vim git networkmanager efibootmgr ly dhcpcd bluez bluez-utils bluez-obex openssh wireless-regdb
```

## Efibootmgr

```sh
efibootmgr --create \
--disk /dev/sda --part 1 \
--label "Arch EFI" \
--loader /vmlinuz-linux \
--unicode 'root=UUID=b2978444-769b-4d1b-8061-c1ac685e5fc7 rw loglevel=3 quiet splash initrd=\initramfs-linux.img'
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

````

### GPU Driver

Install graphic driver:

- Intel graphics: `xf86-video-intel` and `mesa`
- Nvidia graphics: Turing serias or newer `nvidia-open` else `nvidia`

### Optimus Manager

```sh
pacman -S optimus-manager
systemctl enable optimus-manager
````

Need add `prime-offload` to configuration:

```sh
exec --no-startup-id prime-offload
```

Can check the optimus-manager status:

```sh
optimus-manager --status
```

### Fcitx5

`/etc/environment`:

```sh
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

### Bluetooth

```sh
sudo pacman -S bluez bluez-utils bluez-obex
sudo systemctl enable --now bluetooth
```

### Default browser

Modified `$HOME/.config/mimeapps.list`

```dosini
[Default Applications]
x-scheme-handler/https=firefox.desktop
x-scheme-handler/http=firefox.desktop
```
