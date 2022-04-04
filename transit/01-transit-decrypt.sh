#!/bin/bash

# Encrypt
CIPHERTEXT=$( vault write -format=json transit/encrypt/pin-batch-01 \
                plaintext=$(base64 <<< "4111 1111 1111 1111") \
             | jq -r .data.ciphertext )

echo
echo ciphertext: $CIPHERTEXT
echo

# Decrypt
PLAINTEXT=$( vault write -format=json transit/decrypt/pin-batch-01 \
                ciphertext=$CIPHERTEXT  \
             | jq -r .data.plaintext | base64 -d )

echo
echo plaintext: $PLAINTEXT
echo
