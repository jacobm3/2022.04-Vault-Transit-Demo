#!/bin/bash -x 

export VAULT_NAMESPACE=pin-demo

vault secrets enable -path=secret -version=2 kv

vault secrets tune \
  -audit-non-hmac-response-keys=description \
  secret

