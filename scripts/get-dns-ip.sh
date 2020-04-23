#!/bin/sh

API_HOST="https://api.linode.com/v4"
TOKEN=$1
DOMAIN_ID=$2
RECORD_ID=$3

# Get the currently configured IP address in Linode's DNS
RESPONSE=$(curl -s -H "Authorization: Bearer $TOKEN" "$API_HOST/domains/$DOMAIN_ID/records/$RECORD_ID")
# Response example: 
# {"id": 123456, "type": "A", "name": "zero", "target": "123.45.67.890", "priority": 0, "weight": 0, "port": 0, "service": null, "protocol": null, "ttl_sec": 300, "tag": null, "created": "2020-04-20T21:58:47", "updated": "2020-04-20T21:58:47"}

# Parse the output for the IP address
DNSIP=`echo $RESPONSE | sed -n 's|.*"target":[[:space:]]"\([^"]*\)".*|\1|p'`
# Thanks god this guy exists: https://raymii.org/s/snippets/Get_json_value_with_sed.html

echo $DNSIP