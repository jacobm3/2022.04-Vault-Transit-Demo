#!/bin/bash

batch=01
for x in $(seq -w 1 10); do
  vault kv put secret/3des-key-batch-${batch}/key-${batch}-${x} \
    key=$(openssl rand -base64 21)
done



