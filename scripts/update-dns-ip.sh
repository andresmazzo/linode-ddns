#!/bin/sh

API_HOST="https://api.linode.com/v4"
TOKEN=$1
DOMAIN_ID=$2
RECORD_ID=$3
NEW_IP=$4

# Update Linode Record DNS IP
curl -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -X PUT -d '{
      "type": "A",
      "name": "zero",
      "target": "'"$NEW_IP"'",
      "priority": 50,
      "weight": 50,
      "port": 80,
      "service": null,
      "protocol": null,
      "ttl_sec": 604800,
      "tag": null
    }' \
    $API_HOST/domains/$DOMAIN_ID/records/$RECORD_ID
