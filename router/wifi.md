# Setup AP

```bash
pacman -S firewalld network-manager iptables dnsmasq dhcp dhcpcd hostapd
```

```sh
systemctl enable iptables dnsmasq dhcpcd
```

```sh
firewall-cmd --permanent --new-zone=hotspot
firewall-cmd --permanent --zone=hotspot --add-service=dhcp
firewall-cmd --permanent --zone=hotspot --add-service=dns
firewall-cmd --permanent --zone=hotspot --add-interface=ap0

firewall-cmd --permanent --zone=hotspot --add-rich-rule='rule family="ipv4" forward-port port="53" protocol="udp" to-port="5353" destination address="192.168.12.1"'

firewall-cmd --permanent --zone=public --add-masquerade
firewall-cmd --permanent --new-policy hotspot-forwarding
firewall-cmd --permanent --policy hotspot-forwarding --add-ingress-zone hotspot

firewall-cmd --permanent --policy hotspot-forwarding --add-egress-zone public
firewall-cmd --permanent --policy hotspot-forwarding --set-target ACCEPT
firewall-cmd --reload
```

require `AUR` package `create_ap`:

```sh
git clone https://aur.archlinux.org/linux-wifi-hotspot.git
```
