# kv secrets
path "secret/*" {
    capabilities = ["create", "read", "list", "update", "delete"]
}

# encryption
path "transit/encrypt/pin-batch-0001" {
   capabilities = [ "update" ]
}

path "transit/decrypt/pin-batch-0001" {
   capabilities = [ "update" ]
}

path "transit/*" {
   capabilities = [ "list", "read", "update" ]
}


