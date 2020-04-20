#!/bin/bash
 
BASE=`basename $0 .sh`
DIR=`dirname $0`

OUTPUT1=/tmp/$BASE-1.out
OUTPUT2=/tmp/$BASE-2.out

# Read the configuration file
CONF=$DIR/$BASE.conf
if [ -r "$CONF" ]; then
  . $CONF
else 
  logger -t $BASE "Could not read configuration file: $CONF"
  exit 1
fi

# External Ethernet interface
IFACE=`uci get network.wan.ifname`

# Get the current external IP address
CURRIP=`ifconfig $IFACE | grep 'inet addr' | awk '/inet addr/ {print $2}' | awk -F: '{print $2}'`

# Get the currently configured IP address in Linode's DNS
curl -H "Authorization: Bearer $TOKEN" https://api.linode.com/v4/domains/$DOMAIN_ID/records/$RECORD_ID
RC=$?
if [ "$RC" != 0 ];then 
  logger -t $BASE "curl list reported error: $RC"
  exit 2
fi

# Parse the output for the IP address
DNSIP=`cat $OUTPUT1 | sed -e 's/^.*"TARGET":"//' -e 's/",.*$//'`

if [ "$DNSIP" = "$CURRIP" ]; then
  logger -t $BASE "External IP address has not changed. No IP update necessary. IP address: $CURRIP"
  exit 0
fi

# Update Linode Record DNS IP
curl -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -X PUT -d '{
      "type": "A",
      "name": "zero",
      "target": "$CURRIP",
      "priority": 50,
      "weight": 50,
      "port": 80,
      "service": null,
      "protocol": null,
      "ttl_sec": 604800,
      "tag": null
    }' \
    https://api.linode.com/v4/domains/$DOMAIN_ID/records/$RECORD_ID

RC=$?
if [ "$RC" != 0 ];then 
  logger -t $BASE "Curl update reported error: $RC"
  exit 2
fi

# Log the IP address change
logger -t $BASE "Updated IP address from $DNSIP to $CURRIP"
