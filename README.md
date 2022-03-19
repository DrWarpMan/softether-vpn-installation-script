# softether-vpn-installation-script
Simple SoftEther VPN installation script for Debian-based systems.
I made this script for myself, I bear no responsibility for any damage it may cause to your system, if you don't know how to use it, then don't.

***NOTE:** This script is only working with root!*

## Guide
1. `apt update -y && apt upgrade -y`
2. Install dependencies: `apt install nano tar wget build-essential libssl-dev libreadline-dev libxtst-dev git libncurses5-dev dh-exec zlib1g-dev expect pwgen -y`
3. `reboot` (optional)
4. Clone: `git clone https://github.com/DrWarpMan/softether-vpn-installation-script.git`
5. Cd into the directory: `cd softether-vpn-installation-script`
6. Setup permissions: `chmod +x ./install.sh`
7. Run: `./install.sh` and put in your credentials or just press ENTER to generate them for you

If the installation was successful, you can use the credentials the script gave you to login.
VPN server is set to be automatically started at boot, and also is automatically running after the script finishes.


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

