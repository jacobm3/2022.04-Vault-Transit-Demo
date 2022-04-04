#!/bin/bash

set -e

FILE=$1

if [ ! -r $FILE ]; then
  echo "File not readable: $FILE"
  exit 1
fi

export VAULT_NAMESPACE=pin-demo

echo "Base64 encoding ${FILE} to ${FILE}.b64"
base64 $FILE > ${FILE}.b64

# Encrypt
echo "Encrypting ${FILE}.b64 with Vault Transit, to ${FILE}.ciphertext"
vault write -format=json transit/encrypt/pin-batch-01 \
                plaintext=@${FILE}.b64 \
             | jq -r .data.ciphertext > ${FILE}.ciphertext

# Decrypt
echo "Decrypting file with Vault Transit to new.${FILE}"
vault write -format=json transit/decrypt/pin-batch-01 \
                ciphertext=@${FILE}.ciphertext  \
             | jq -r .data.plaintext | base64 -d > new.${FILE}

