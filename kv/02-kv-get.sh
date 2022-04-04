#!/bin/bash -x 
vault kv get secret/hello 
vault kv get -format=json secret/hello 

vault kv get secret/app1/db-conn-str
