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

`/etc/sysctl.d/`

Enable ip forward

```sh
net.ipv4.ip_forward = 1
net.ipv4.conf.all.forwarding = 1
net.ipv6.conf.all.forwarding = 1
```

Improvent:

```sh
net.core.rmem_default = 1048576
net.core.rmem_max = 16777216
net.core.wmem_default = 1048576
net.core.wmem_max = 16777216
net.core.optmem_max = 65536
net.ipv4.tcp_rmem = 4096 1048576 2097152
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.udp_rmem_min = 8192
net.ipv4.udp_wmem_min = 8192
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_max_syn_backlog = 8192
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_keepalive_time = 60
net.ipv4.tcp_keepalive_intvl = 10
net.ipv4.tcp_keepalive_probes = 6
net.ipv4.tcp_mtu_probing = 1
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_sack = 1
net.core.default_qdisc = cake
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv4.conf.all.secure_redirects = 0
net.ipv4.conf.default.secure_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0
net.ipv4.icmp_echo_ignore_all = 1
net.ipv6.icmp.echo_ignore_all = 1
```

Add `tcp_bbr` to `/etc/modules-load.d/modules.conf`

require `AUR` package `create_ap`:

```sh
git clone https://aur.archlinux.org/linux-wifi-hotspot.git
```
