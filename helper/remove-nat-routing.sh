#!/bin/bash
IPT="/sbin/iptables"

IN_160="ens160"
IN_192="ens192"                   # NIC connected to the internet
WG_FACE="wg0"                    # WG NIC
SUB_NET="172.16.250.0/24"            # WG IPv4 sub/net aka CIDR
WG_PORT="34571"                  # WG udp port

# IPv4 rules #
$IPT -t nat -D POSTROUTING -s $SUB_NET -o $IN_160 -j MASQUERADE
$IPT -t nat -D POSTROUTING -s $SUB_NET -o $IN_192 -j MASQUERADE
$IPT -D INPUT -i $WG_FACE -j ACCEPT
$IPT -D FORWARD -i $IN_160 -o $WG_FACE -j ACCEPT
$IPT -D FORWARD -i $IN_192 -o $WG_FACE -j ACCEPT
$IPT -D FORWARD -i $WG_FACE -o $IN_160 -j ACCEPT
$IPT -D FORWARD -i $WG_FACE -o $IN_192 -j ACCEPT
$IPT -D INPUT -i $IN_160 -p udp --dport $WG_PORT -j ACCEPT
$IPT -D INPUT -i $IN_192 -p udp --dport $WG_PORT -j ACCEPT