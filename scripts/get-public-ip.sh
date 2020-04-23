#!/bin/sh

# External Ethernet interface
IFACE=`uci get network.wan.ifname`
# Get the current external IP address
CURRIP=`ifconfig $IFACE | grep 'inet addr' | awk '/inet addr/ {print $2}' | awk -F: '{print $2}'`

echo $CURRIP