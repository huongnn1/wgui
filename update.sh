#!/bin/bash

VER=$(curl -sI https://github.com/ngoduykhanh/wireguard-ui/releases/latest | grep "location:" | cut -d "/" -f8 | tr -d '\r')

echo "downloading wireguard-ui $VER"
curl -sL "https://github.com/ngoduykhanh/wireguard-ui/releases/download/$VER/wireguard-ui-$VER-linux-amd64.tar.gz" -o wireguard-ui-$VER-linux-amd64.tar.gz

echo -n "extracting "; tar xvf wireguard-ui-$VER-linux-amd64.tar.gz

echo "restarting wgui-web.service"
systemctl restart wgui-web.service
