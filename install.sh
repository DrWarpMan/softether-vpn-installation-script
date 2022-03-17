#!/bin/bash

NAME="admin"
PASSWORD=$(pwgen 8 1)

echo "SoftEther VPN installation script, made by DrWarpMan@gmail.com"

echo "Getting script path.."
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo "Clearing any previous installations.."

systemctl stop vpnserver
rm /lib/systemd/system/vpnserver.service
rm -rf /usr/local/vpnserver

echo "Downloading SoftEther VPN source.."
git clone https://github.com/SoftEtherVPN/SoftEtherVPN_Stable.git

echo "Configuring build.."
(cd $SCRIPT_DIR/SoftEtherVPN_Stable/ && ./configure)
echo "Trying to build from source, this may take a while.."
(cd $SCRIPT_DIR/SoftEtherVPN_Stable/ && make -w --silent > /dev/null 2>&1)

echo "Moving vpnserver to /usr/local/vpnserver.."
mkdir /usr/local/vpnserver/
mv $SCRIPT_DIR/SoftEtherVPN_Stable/bin/vpnserver/* /usr/local/vpnserver/
mv $SCRIPT_DIR/SoftEtherVPN_Stable/bin/vpncmd/* /usr/local/vpnserver/

echo "Setting up permissions.."
chmod 700 /usr/local/vpnserver/vpnserver
chmod 700 /usr/local/vpnserver/vpncmd

echo "Creating startscript.."
cat <<EOT > /lib/systemd/system/vpnserver.service
[Unit]
Description=SoftEther VPN Server
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/vpnserver/vpnserver start
ExecStop=/usr/local/vpnserver/vpnserver stop

[Install]
WantedBy=multi-user.target
EOT

echo "Starting up vpnserver.service.."

systemctl daemon-reload
systemctl enable vpnserver
systemctl start vpnserver

echo "Configuring vpnserver.."

sleep 5

expect $SCRIPT_DIR/configure.exp $NAME $PASSWORD

echo "Done, if everything went correctly, credentials are:"
echo "HUB: VPN, USERNAME: $NAME, PASSWORD: $PASSWORD"
