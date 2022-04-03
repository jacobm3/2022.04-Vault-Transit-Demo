#!/bin/bash -x 

vault kv put secret/cookies/sugar ingredients=sugar,butter,flour,milk temp=325
vault kv put secret/cookies/oatmeal ingredients=oatmeal,raisins,sugar,butter,flour,milk temp=400


vault kv get secret/cookies/sugar 
vault kv get -format=json secret/cookies/oatmeal 
