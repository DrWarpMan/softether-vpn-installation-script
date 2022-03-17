# softether-vpn-installation-script
Simple SoftEther VPN installation script for Debian-based systems

Note: This script is only working with root!

Before running:
apt update && apt upgrade

Install dependencies:
apt install nano tar wget build-essential libssl-dev libreadline-dev libxtst-dev git libncurses5-dev dh-exec zlib1g-dev expect pwgen -y
(reboot possibly)

Oracle commands:
```
iptables -F

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -t nat -F
iptables -t mangle -F
iptables -F
iptables -X

ip6tables -P INPUT ACCEPT
ip6tables -P FORWARD ACCEPT
ip6tables -P OUTPUT ACCEPT
ip6tables -t nat -F
ip6tables -t mangle -F
ip6tables -F
ip6tables -X

/sbin/iptables-save > /etc/iptables/rules.v4
/sbin/ip6tables-save > /etc/iptables/rules.v6
```

