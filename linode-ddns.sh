#!/bin/sh
 
BASE=`basename $0 .sh`
DIR=`dirname $0`

# Read the configuration file
CONF=$DIR/vars.conf
if [ -r "$CONF" ]; then
  . $CONF
else 
  logger -t $BASE "Could not read configuration file: $CONF"
  exit 1
fi

CURRIP=`"$DIR/scripts/get-public-ip.sh"`
RC=$?
if [ "$RC" != 0 ];then 
  logger -t $BASE "Cannot get public IP address: $RC"
  exit 2
fi

DNSIP=`"$DIR/scripts/get-dns-ip.sh" $TOKEN $DOMAIN_ID $RECORD_ID`
RC=$?
if [ "$RC" != 0 ];then 
  logger -t $BASE "Curl get reported error: $RC"
  exit 2
fi

if [ "$DNSIP" = "$CURRIP" ]; then
  logger -t $BASE "External IP address has not changed. No IP update necessary. IP address: $CURRIP"
  exit 0
fi

`"$DIR/scripts/update-dns-ip.sh" $TOKEN $DOMAIN_ID $RECORD_ID $CURRIP`
RC=$?
if [ "$RC" != 0 ];then 
  logger -t $BASE "Curl update reported error: $RC"
  exit 2
fi

# Log the IP address change
logger -t $BASE "Updated IP address from $DNSIP to $CURRIP"
