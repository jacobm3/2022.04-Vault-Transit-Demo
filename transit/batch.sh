curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    --data @batch-encrypt.json \
    http://127.0.0.1:8200/v1/transit/encrypt/orders

