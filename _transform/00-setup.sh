vault secrets enable transform
vault write transform/role/payments transformations=card-number
vault list transform/role
vault write transform/transformations/fpe/card-number \
    template="builtin/creditcardnumber" \
    tweak_source=internal \
    allowed_roles=payments
vault list transform/transformations/fpe
vault read transform/transformations/fpe/card-number

vault write transform/encode/payments value=1111-2222-3333-4444
vault write transform/encode/payments value=1111-2222-3333-4444
echo vault write transform/decode/payments value=8492-9808-1939-2623


