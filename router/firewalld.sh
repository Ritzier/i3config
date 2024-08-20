systemctl enable firewalld
systemctl start firewalld
firewall-cmd --permanent --new-zone=hotspot
firewall-cmd --permanent --zone=hotspot --add-service=dhcp
firewall-cmd --permanent --zone=hotspot --add-service=dns
firewall-cmd --permanent --zone=hotspot --add-interface=ap0

# Ensure the DNS ports are forwarded
firewall-cmd --permanent --zone=hotspot --add-rich-rule='rule family="ipv4" forward-port port="53" protocol="tcp" to-port="5353" destination address="192.168.12.1"'
firewall-cmd --permanent --zone=hotspot --add-rich-rule='rule family="ipv4" forward-port port="53" protocol="udp" to-port="5353" destination address="192.168.12.1"'

# Change public to whatever zone you've assigned the internet connection to
firewall-cmd --permanent --zone=public --add-masquerade

firewall-cmd --permanent --new-policy hotspot-forwarding
firewall-cmd --permanent --policy hotspot-forwarding --add-ingress-zone hotspot
# Change public to whatever zone you've assigned the internet connection to
firewall-cmd --permanent --policy hotspot-forwarding --add-egress-zone public
# If you want to restrict what ports clients can access on the internet, you can remove this
firewall-cmd --permanent --policy hotspot-forwarding --set-target ACCEPT
# And add specific services instead
#firewall-cmd --permanent --policy hotspot-forwarding --add-service http

firewall-cmd --reload
