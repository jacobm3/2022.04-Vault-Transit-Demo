#!/bin/bash 

set -e
set -x

while [ "$(pgrep vault)" ]; do
  pkill vault
  sleep 0.5
done

rm -fr data vault.log vault.err

vault server -config=vault.hcl >vault.log 2>vault.err &

sleep 1

export VAULT_ADDR="https://localhost.theneutral.zone:8200"
unset VAULT_NAMESPACE

vault operator init -format=json -t 1 -n 1 | tee .init.json

vault operator unseal $(jq -r .unseal_keys_b64[0] < .init.json)

vault login $(jq -r .root_token < .init.json)

vault audit enable file file_path=audit hmac_accessor=false


