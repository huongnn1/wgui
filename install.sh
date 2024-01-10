#!/bin/bash
#Huong Nguyen 10/01/2024
#Source wireguard-ui: https://github.com/ngoduykhanh/wireguard-ui
IP_WAN=$(curl ifconfig.co)

#Step 1: Update repository linux
echo "------------Updating repository------------"
apt update

#Step 2: Install wireguard
echo "------------Installing wireguard------------"
apt install wireguard -y

#Step 3: Enable IP forwarding
echo "------------Enable IP forwarding------------"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf

#Step 4: Cloning source code
echo "------------Cloning source code------------"
cd /etc/wireguard/
git clone https://github.com/huongnn1/wgui.git

#Step 5: Moving to /etc/wireguard/
echo "------------Moving source code to /etc/wireguard------------"
mv /etc/wireguard/wgui/* /etc/wireguard/

#Step 6: Set permission excute
chmod +x -R /etc/wireguard/*

#Step 7: Copy file services to /etc/systemd/system/ then reload daemon
echo "------------Copying file services to /etc/sytemd/system/------------"
cp /etc/wireguard/systemd/* /etc/systemd/system/
systemctl daemon-reload

#Step 8: Update wireguard-ui
echo "------------Updating source code wireguard-ui------------"
cd /etc/wireguard/
./update.sh
echo "------------Done !!!------------"

#Step 7: Enable - start services
echo "------------Apply config wireguard------------"
# wg setconf wg0 /etc/wireguard/wg0.conf
echo "------------Enable services------------"
systemctl enable wgui.{path,service} wg-quick@wg0.service wgui-web.service
echo "------------Start services------------"
systemctl start wgui.{path,service}
echo "-------Access URL: https://$IP_WAN:5000"
