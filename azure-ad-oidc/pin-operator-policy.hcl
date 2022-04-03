# kv secrets
path "secret/*" {
    capabilities = ["read", "list"]
}

# encryption
path "transit/encrypt/pin-batch-0001" {
   capabilities = [ "update" ]
}

path "transit/decrypt/pin-batch-0001" {
   capabilities = [ "update" ]
}
