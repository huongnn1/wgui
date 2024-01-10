#!/bin/bash

#Step 1: Update repository linux
echo "Updating repository..."
apt update

#Step 2: Install wireguard
echo "Installing wireguard..."
apt install wireguard -y

#Step 3: Enable IP forwarding
echo "Enable IP forwarding..."
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

#Step 4: Git clone source
echo "Cloing source code..."
cd /etc/wireguard/
git clone https://github.com/huongnn1/wgui.git
echo "Moving source code to /etc/wireguard..."
mv /etc/wireguard/wgui/* /etc/wireguard/
chmod +x -R /etc/wireguard/*

#Step 5: Copy file to /etc/systemd/system/ then reload daemon
echo "Copying file services to /etc/sytemd/system/..."
cp /etc/wireguard/systemd/* /etc/systemd/system/
systemctl daemon-reload

#Step 6: Update wireguard-ui
echo "Updating source code wireguard-ui..."
chmod +x /etc/wireguard/update.sh
cd /etc/wireguard/
./update.sh

#Step 7: Enable - start services
wg setconf wg0 /etc/wireguard/wg0.conf
systemctl enable wgui.{path,service} wg-quick@wg0.service wgui-web.service
systemctl start wgui.{path,service}