curl -s "https://archlinux.org/mirrorlist/?country=SG&protocol=https&ip_version=4" | sed 's/^#Server/Server/' > mirrorlist.txt
