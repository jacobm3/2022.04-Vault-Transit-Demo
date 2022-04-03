vault secrets enable pki

vault secrets tune -max-lease-ttl=87600h pki

vault write pki/root/generate/internal common_name=hashicorp.com ttl=87600h 

# import the issuing CA cert into Windows like this from an admin powershell - 
# PS C:\users\jacob>  certutil -addstore -enterprise -f "CA" test-ca.pem

vault write pki/config/urls \
    issuing_certificates="http://vault.hashicorp.com:8200/v1/pki/ca" \
    crl_distribution_points="http://vault.hashicorp.com:8200/v1/pki/crl"

vault write pki/roles/hashicorp-test-dot-com \
    allowed_domains=hashicorp-test.com \
    allow_bare_domains=true \
    allow_subdomains=true max_ttl=72h \
    key_bits=4096


vault write pki/issue/hashicorp-test-dot-com \
    common_name=app1.hashicorp-test.com 


