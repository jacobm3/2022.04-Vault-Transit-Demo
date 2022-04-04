#!/bin/bash

export VAULT_NAMESPACE=pin-demo

KEYNAME=proj-a-3des-key

# create a key, not exportable
vault write -f transit/keys/$KEYNAME \
  exportable="true" \
  auto_rotate_period=3600 

vault read -format=json \
  transit/export/encryption-key/$KEYNAME

# Retrieve the transit-generated key, base64 decode it to raw bytes,
# drop remaining bytes after first 21, base64 encode and return
KEY=$( vault read -format=json  \
  transit/export/encryption-key/${KEYNAME}/latest \
  | jq -r .data.keys[] | base64 -d | head -c 21 | base64 )

echo $KEY
