#!/bin/bash -x 

vault secrets disable secret
vault secrets enable -version=2 -path=secret kv

vault secrets tune \
  -audit-non-hmac-response-keys=description \
  -audit-non-hmac-response-keys=accessor \
  -audit-non-hmac-response-keys=client_token_accessor \
  -audit-non-hmac-request-keys=accessor \
  -audit-non-hmac-request-keys=client_token_accessor \
  secret

vault kv put secret/hello foo=world excited=yes

vault kv put secret/goodbye foo="cruel world" excited=no

vault kv put secret/jmartinson first=Jacob last=Martinson SSN=123-45-1877

vault kv put secret/app1/db-conn-str str="mysql://user@db5.internal:3306?get-server-public-key=true" team="na-devops" environment="test"
vault kv metadata put -custom-metadata team="south" secret/app1/db-conn-str


