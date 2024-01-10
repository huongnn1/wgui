#!/bin/bash
IP_WAN=curl ifconfig.co
./etc/wireguard/wireguard-ui $IP_WAN 0.0.0.0:5000
