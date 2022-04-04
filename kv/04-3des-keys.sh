#!/bin/bash

vault kv put secret/pin-3des-key key=$(openssl rand -base64 21)

vault kv get secret/pin-3des-key 


