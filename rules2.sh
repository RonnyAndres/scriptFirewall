#!/bin/sh

# Instalar paquetes
apk add nano
apk add iptables

# Cambiar /etc/resolv.conf
echo "nameservers 8.8.8.8" > /etc/resolv.conf

# Configurar interfaces de red
cat << EOF > /etc/network/interfaces

auto lo
iface lo inet loopback

auto eth1
iface eth1 inet static
address 192.168.122.200
netmask 255.255.255.0
gateway 192.168.122.1

auto eth2
iface eth2 inet static
address 192.168.122.201
netmask 255.255.255.0
gateway 192.168.122.1

auto eth3
iface eth3 inet static
address 192.168.1.1
netmask 255.255.255.0
EOF

# Agregar reglas de iptables
iptables -A OUTPUT -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -p tcp -m multiport --dports 22,25,110,143 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 22,25,110,143 -j DROP
iptables -A INPUT -p tcp --dport 80 -i eth1 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -i eth2 -j ACCEPT
iptables -A INPUT -i eth1 -j DROP
iptables -A INPUT -i eth2 -j DROP
iptables -A INPUT -p tcp --dport 443 -d 192.168.122.200 -j DROP 
iptables -A INPUT -p tcp --dport 443 -d 192.168.122.201 -j ACCEPT
iptables -A INPUT -d 192.168.122.200 -j DROP



