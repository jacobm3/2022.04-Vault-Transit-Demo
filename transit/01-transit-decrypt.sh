#!/bin/bash

ORIG="4111 1111 1111 1111"

echo
echo original plaintext: $ORIG
echo

# Encrypt
CIPHERTEXT=$( vault write -format=json transit/encrypt/pin-batch-01 \
                plaintext=$(base64 <<< $ORIG ) \
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
