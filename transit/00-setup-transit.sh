#!/bin/bash -x

export VAULT_NAMESPACE=pin-demo

# enable secrets engines
vault secrets enable transit

# create a key, not exportable
vault write -f transit/keys/pin-batch-01

vault write transit/encrypt/pin-batch-01 \
    plaintext=$(base64 <<< "4111 1111 1111 1111")

# rotate key
vault write -f transit/keys/pin-batch-01/rotate

vault write transit/encrypt/pin-batch-01 \
    plaintext=$(base64 <<< "4111 1111 1111 1111")

