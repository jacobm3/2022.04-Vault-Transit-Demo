#!/bin/bash -x 

export VAULT_NAMESPACE=pin-demo

vault kv put secret/hello foo=world excited=yes

vault kv put secret/goodbye foo="cruel world" excited=no

vault kv put secret/app1/db-conn-str \
  str="mysql://user@db5.internal:3306?get-server-public-key=true" \
  environment="test"

vault kv metadata put -custom-metadata team="south" secret/app1/db-conn-str


