#!/bin/bash
IPT="/sbin/iptables"

IN_160="ens160"
IN_192="ens192"                  # NIC connected to the internet
WG_FACE="wg0"                    # WG NIC
SUB_NET="172.16.150.0/24"        # WG IPv4 sub/net aka CIDR
WG_PORT="12321"                  # WG udp port

## IPv4 ##
$IPT -t nat -I POSTROUTING 1 -s $SUB_NET -o $IN_160 -j MASQUERADE
$IPT -t nat -I POSTROUTING 1 -s $SUB_NET -o $IN_192 -j MASQUERADE
$IPT -I INPUT 1 -i $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $IN_160 -o $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $IN_192 -o $WG_FACE -j ACCEPT
$IPT -I FORWARD 1 -i $WG_FACE -o $IN_160 -j ACCEPT
$IPT -I FORWARD 1 -i $WG_FACE -o $IN_192 -j ACCEPT
$IPT -I INPUT 1 -i $IN_160 -p udp --dport $WG_PORT -j ACCEPT
$IPT -I INPUT 1 -i $IN_192 -p udp --dport $WG_PORT -j ACCEPT
ip route add 10.0.0.0/8 via 10.248.136.254 dev $IN_192
