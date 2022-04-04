#!/bin/bash

vault kv get secret/3des-key-batch-01/key-01-10

echo; echo; echo

vault kv get -version=1 secret/3des-key-batch-01/key-01-10
