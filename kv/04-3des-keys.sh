#!/bin/bash

vault kv put secret/pin-3des-key key=$(openssl rand -base64 24)

vault kv get secret/pin-3des-key 


