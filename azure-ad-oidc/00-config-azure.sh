#!/bin/bash

# https://learn.hashicorp.com/tutorials/vault/oidc-auth-azure?in=vault/auth-methods

export VAULT_ADDR=https://localhost.theneutral.zone:8200

export AD_AZURE_DISPLAY_NAME=vault-demo-2022.04

# Use web browser to authenticate Azure CLI 
az login

# Register a web app for Vault with two redirect URIs (also called reply-urls). 
# One URI is for Vault CLI access and the second is for UI access. Save the #
# application ID to the AD_VAULT_APP_ID environment variable.
export AD_VAULT_APP_ID=$(az ad app create \
   --display-name ${AD_AZURE_DISPLAY_NAME} \
   --reply-urls "http://localhost:8250/oidc/callback" \
   "${VAULT_ADDR}/ui/vault/auth/oidc/oidc/callback" | \
   jq -r '.appId')

# Retrieve the application ID of the Microsoft Graph API, which allows you to 
# access Azure service resources. This ID will be used to attach API permissions 
# to the app registration.
export AD_MICROSOFT_GRAPH_API_ID=$(az ad sp list \
   --filter "displayName eq 'Microsoft Graph'" \
   --query '[].appId' -o tsv)

# Using the Microsoft Graph API ID, retrieve the ID of the permission 
# for GroupMember.Read.All
export AD_PERMISSION_GROUP_MEMBER_READ_ALL_ID=$(az ad sp show \
   --id ${AD_MICROSOFT_GRAPH_API_ID} \
   --query "oauth2Permissions[?value=='GroupMember.Read.All'].id" -o tsv)

# Add the GroupMember.Read.All permission to the application. This allows the 
# application to read an Active Directory group and its users.
az ad app permission add \
   --id ${AD_VAULT_APP_ID} \
   --api ${AD_MICROSOFT_GRAPH_API_ID} \
   --api-permissions ${AD_PERMISSION_GROUP_MEMBER_READ_ALL_ID}=Scope
# Invoking "az ad app permission grant --id fa60f935-e94f-4ae4-bef7-9af7698c679a --api 00000003-0000-0000-c000-000000000000" is needed to make the change effective

# Create a service principal to attach to the application. The service 
# principal allows you to grant administrative consent from the Azure CLI.
az ad sp create --id ${AD_VAULT_APP_ID}


# Grant administrative consent for the application to access the Microsoft Graph API.
az ad app permission grant --id ${AD_VAULT_APP_ID} \
    --api ${AD_MICROSOFT_GRAPH_API_ID}



# Retrieve the Azure tenant ID for the application and set it to the AD_TENANT_ID 
# environment variable.
export AD_TENANT_ID=$(az ad sp show --id ${AD_VAULT_APP_ID} \
   --query 'appOwnerTenantId' -o tsv)

# Reset the client secret for the application and set the password to the 
# AD_CLIENT_SECRET environment variable. You will need the secret to configure 
# the OIDC auth method in Vault.
export AD_CLIENT_SECRET=$(az ad app credential reset \
    --id ${AD_VAULT_APP_ID} | jq -r '.password')

# Create a file named manifest.json with the specification for an ID token for an AD group.

cat > manifest.json << EOF
{
    "idToken": [
        {
            "name": "groups",
            "additionalProperties": []
        }
    ]
}
EOF

# Update the application with the claims manifest in manifest.json and set 
# groupMembershipClaims to SecurityGroup
az ad app update --id ${AD_VAULT_APP_ID} \
    --set groupMembershipClaims=SecurityGroup \
    --optional-claims @manifest.json

