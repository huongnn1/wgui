#!/bin/bash

#Step 1: Update repository linux
apt update & apt upgrade -y

#Step 2: Install wireguard
apt install wireguard -y

#Step 3: Enable IP forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

#Step 4: Git clone source
cd /etc/wireguard/
git clone https://github.com/huongnn1/wgui.git
mv -r /etc/wireguard/wgui/* /etc/wireguard/

#Step 5: Copy file to /etc/systemd/system/ then reload daemon
cp /etc/wireguard/systemd/* /etc/systemd/system/
systemctl daemon-reload

#Step 6: Update wireguard-ui
chmod +x /etc/wireguard/update.sh
./etc/wireguard/update.sh

#Step 7: Enable - start services
wg setconf wg0 /etc/wireguard/wg0.conf
systemctl enable wgui.{path,service} wg-quick@wg0.service wgui-web.service
systemctl start wgui.{path,service}