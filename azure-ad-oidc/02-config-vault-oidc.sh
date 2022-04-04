#!/bin/bash

set -e
set -x

NS=pin-demo
export VAULT_NAMESPACE=$NS

# Configure Vault with the OIDC auth method
export VAULT_LOGIN_ROLE=pin
vault auth enable oidc
vault write auth/oidc/config \
    oidc_client_id="${AD_VAULT_APP_ID}" \
    oidc_client_secret="${AD_CLIENT_SECRET}" \
    default_role="${VAULT_LOGIN_ROLE}" \
    oidc_discovery_url="https://login.microsoftonline.com/${AD_TENANT_ID}/v2.0"

vault write auth/oidc/role/${VAULT_LOGIN_ROLE} \
   user_claim="email" \
   allowed_redirect_uris="http://localhost:8250/oidc/callback" \
   allowed_redirect_uris="${VAULT_ADDR}/ui/vault/auth/oidc/oidc/callback"  \
   groups_claim="groups" \
   policies="" \
   oidc_scopes="https://graph.microsoft.com/.default"

export VAULT_OIDC_ACCESSOR_ID=$(vault auth list -format=json | \
   jq -r '."oidc/".accessor')

# Group: pin-operator
# Set up a Vault external group for the AD group
# This expects the AD group to already exist, in this case, "pin-demo-ad-group"
export AD_GROUP_ID=$(az ad group show \
   --group pin-demo-ad-group \
   --query objectId -o tsv)

export VAULT_GROUP_ID=$(vault write \
   -field=id -format=table \
   identity/group \
   name="pin-operator" \
   type="external" \
   policies="pin-operator")

# Map the AD group ID to the Vault external group ID for the OIDC auth mount
vault write identity/group-alias \
  name=$AD_GROUP_ID \
  mount_accessor=$VAULT_OIDC_ACCESSOR_ID \
  canonical_id=$VAULT_GROUP_ID


# Group: ns-pin-admin
# second group, namespace admins
export AD_GROUP_ID=$(az ad group show \
   --group ns-pin-admin \
   --query objectId -o tsv)

export VAULT_GROUP_ID=$(vault write \
   -field=id -format=table \
   identity/group \
   name="ns-pin-demo-ns-admin" \
   type="external" \
   policies="ns-admin")

# Map the AD group ID to the Vault external group ID for the OIDC auth mount
vault write identity/group-alias \
  name=$AD_GROUP_ID \
  mount_accessor=$VAULT_OIDC_ACCESSOR_ID \
  canonical_id=$VAULT_GROUP_ID
