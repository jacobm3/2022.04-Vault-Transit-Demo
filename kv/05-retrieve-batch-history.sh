#!/bin/bash

vault kv get secret/3des-key-batch-01/key-01-20

vault kv get -version=1 secret/3des-key-batch-01/key-01-20
