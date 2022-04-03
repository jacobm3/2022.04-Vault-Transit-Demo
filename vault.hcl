listener "tcp" {
  address = "0.0.0.0:8200"
  tls_cert_file = "/etc/vault.d/tls.crt"
  tls_key_file  = "/etc/vault.d/tls.key"
}

storage "file" {
  path = "data"
}

license_path = "/etc/vault.d/.vault-license"
disable_mlock = true
log_level = "debug"
ui = true
