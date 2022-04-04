#!/bin/bash

NS=pin-demo

vault namespace create $NS

export VAULT_NAMESPACE=$NS

# policy
vault policy write pin-operator pin-operator-policy.hcl
vault policy write ns-admin ns-admin-policy.hcl


