#!/bin/sh

# External Ethernet interface
IFACE=`uci get network.wan.ifname`
# Get the current external IP address
CURRIP=`. /lib/functions/network.sh; network_find_wan NET_IF; network_get_ipaddr NET_ADDR "${NET_IF}"; echo "${NET_ADDR}"`

echo $CURRIP
