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

# Store file
echo "Writing ${FILE}.b64 to Vault KV"
vault kv put secret/${FILE} obj=@${FILE}.b64

# Retrieve file
echo "Retrieving secret/${FILE} from Vault KV, writing to new.${FILE}"
vault kv get -format=json secret/${FILE} \
  | jq -r .data.data.obj | base64 -d > new.${FILE}

# cleanup
rm ${FILE}.b64
