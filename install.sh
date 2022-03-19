#!/bin/bash

echo "SoftEther VPN installation script, made by DrWarpMan@gmail.com"
echo ""
echo "Input your desired global password (default: random)"
read GLOBAL_PASSWORD

echo "Input the new Hub name (default: VPN)"
read HUB_NAME

if [[ -z "$HUB_NAME" ]]; then
    HUB_NAME="VPN"
fi

echo "Input the Hub ($HUB_NAME) password (default: random)"
read HUB_PASSWORD

ACCOUNT_NAME="admin"
echo "Input your Hub ($HUB_NAME) admin account password (default: random)"
read ACCOUNT_PASSWORD

echo "Input your VPN pre-shared key (default: quickvpn)"
read KEY


if [[ -z "$GLOBAL_PASSWORD" ]]; then
    GLOBAL_PASSWORD=$(pwgen 8 1)
fi

if [[ -z "$HUB_PASSWORD" ]]; then
    HUB_PASSWORD=$(pwgen 8 1)
fi

if [[ -z "$ACCOUNT_PASSWORD" ]]; then
    ACCOUNT_PASSWORD=$(pwgen 8 1)
fi

if [[ -z "$KEY" ]]; then
    KEY="quickvpn"
fi

echo "Ready. Script starts now.."

echo ""

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

expect $SCRIPT_DIR/configure.exp $GLOBAL_PASSWORD $HUB_NAME $HUB_PASSWORD $ACCOUNT_NAME $ACCOUNT_PASSWORD $KEY

echo "Script finished."

echo ""

echo "Global password: $GLOBAL_PASSWORD"
echo "Created Hub: $HUB_NAME"
echo "Hub Password: $HUB_PASSWORD"
echo "Hub Account Login: $ACCOUNT_NAME"
echo "Hub Account Password: $ACCOUNT_PASSWORD"
echo "Key: $KEY"