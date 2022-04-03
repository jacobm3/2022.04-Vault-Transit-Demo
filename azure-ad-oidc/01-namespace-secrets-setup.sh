#!/bin/bash

NS=pin-demo

vault namespace create $NS

export VAULT_NAMESPACE=$NS

# enable secrets engines
vault secrets enable -path=secret -version=2 kv

vault secrets enable transit

# create a key
vault write -f transit/keys/pin-batch-0001

# rotate key
# vault write -f transit/keys/pin-batch-0001/rotate

# policy
cat > pin-operator-policy.hcl << EOF
# kv secrets
path "secret/*" {
    capabilities = ["read", "list"]
}

# encryption
path "transit/encrypt/pin-batch-0001" {
   capabilities = [ "update" ]
}

path "transit/decrypt/pin-batch-0001" {
   capabilities = [ "update" ]
}
EOF

vault policy write pin-operator pin-operator-policy.hcl


