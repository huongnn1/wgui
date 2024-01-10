#!/bin/bash
IPT="/sbin/iptables"

IN_FACE=$(ip -o -4 route show to default | awk '{print $5}') # NIC connected to the internet                  
WG_FACE="wg0"                    # WG NIC
SUB_NET="172.16.150.0/24"        # WG IPv4 sub/net aka CIDR
WG_PORT="51820"                  # WG udp port

## IPv4 ##
$IPT -t nat -I POSTROUTING 1 -s $SUB_NET -o $IN_FACE -j MASQUERADE
$IPT -I INPUT 1 -i $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $IN_FACE -o $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $WG_FACE -o $IN_FACE -j ACCEPT
$IPT -I INPUT 1 -i $IN_FACE -p udp --dport $WG_PORT -j ACCEPT