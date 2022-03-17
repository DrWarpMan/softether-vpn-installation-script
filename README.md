# softether-vpn-installation-script
Simple SoftEther VPN installation script for Debian-based systems

*NOTE: This script is only working with root!*

## Guide
1. `apt update -y && apt upgrade -y`
2. Install dependencies: `apt install nano tar wget build-essential libssl-dev libreadline-dev libxtst-dev git libncurses5-dev dh-exec zlib1g-dev expect pwgen -y`
3. `reboot` (optional)
4. Clone: `git clone https://github.com/DrWarpMan/softether-vpn-installation-script.git`
5. Cd into the directory: `cd softether-vpn-installation-script`
6. Setup permissions: `chmod +x ./install.sh`
7. Run: `./install.sh`
8. If everything goes well, the script will give you credentials at the end of the execution.

These commands are to be used with Oracle Cloud VPS:
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

