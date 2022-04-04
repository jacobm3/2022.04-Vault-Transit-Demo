#!/bin/bash

export VAULT_NAMESPACE=pin-demo

# create a key, not exportable
vault write -f transit/keys/pin-exportable \
  exportable="true" \
  auto_rotate_period=3600 

vault read -format=json \
  transit/export/encryption-key/pin-exportable
  
vault write -f transit/keys/pin-exportable/rotate

# Export versions of key
vault read -format=json \
  transit/export/encryption-key/pin-exportable 

# Export latest version of key
vault read -format=json  \
  transit/export/encryption-key/pin-exportable/latest 

vault read -format=json  \
  transit/export/encryption-key/pin-exportable/latest \
  | jq -r .data.keys[]

