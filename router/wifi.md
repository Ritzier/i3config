```bash
pacman -S linux linux-headers linux-firmware base base-devel efibootmgr
```

```bash
pacman -S firewalld network-manager iptables dnsmasq dhcp dhcpcd hostapd
```

```bash
firewall-cmd --permanent --add-port=67/udp
firewall-cmd --permanent --add-port=22/udp
firewall-cmd --permanent --add-port=8000/udp
```
