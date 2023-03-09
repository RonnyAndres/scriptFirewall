#!/bin/bash

# Limpiar todas las reglas existentes y establecer políticas por defecto
iptables -F
iptables -X
iptables -Z
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# Permitir todo el tráfico de salida desde el servidor
iptables -A OUTPUT -j ACCEPT

# Permitir el tráfico entrante a los puertos SSH (22), SMTP (25), POP3 (110) e IMAP (143) solo desde la red interna y bloquear todo el tráfico entrante a estos puertos desde Internet
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 25 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 110 -j ACCEPT
iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 143 -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j DROP
iptables -A INPUT -p tcp --dport 25 -j DROP
iptables -A INPUT -p tcp --dport 110 -j DROP
iptables -A INPUT -p tcp --dport 143 -j DROP

# Permitir el tráfico entrante al puerto HTTP (80) desde Internet, pero bloquear todo el tráfico entrante a otros puertos desde Internet
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 1:79 -j DROP
iptables -A INPUT -p tcp --dport 81:65535 -j DROP

# Permitir el tráfico entrante al puerto HTTPS (443) desde Internet a la dirección IP pública 192.168.122.201 solamente
iptables -A INPUT -p tcp -d 192.168.122.201 --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j DROP

# Bloquear todo el tráfico entrante desde Internet a la dirección IP pública 192.168.122.200
iptables -A INPUT -p all -d 192.168.122.200 -j DROP

# Guardar las reglas de iptables
iptables-save > /etc/iptables/rules.v4

# Mostrar las reglas de iptables configuradas
iptables -L -v
