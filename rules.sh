iptables -A INPUT -s 192.168.1.0/24 -p tcp -m multiport --dports 22,25,110,143 -j ACCEPT
iptables -A INPUT -p tcp -m multiport --dports 22,25,110,143 -j DROP
iptables -A INPUT -p tcp --dport 80 -i eth1 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -i eth2 -j ACCEPT
iptables -A INPUT -i eth1 -j DROP
iptables -A INPUT -i eth2 -j DROP
iptables -A INPUT -p tcp --dport 443 -d 192.168.122.201 -j DROP 
iptables -A INPUT -p tcp --dport 443 -d 192.168.122.202 -j ACCEPT
iptables -A INPUT -d 192.168.122.201 -j DROP

