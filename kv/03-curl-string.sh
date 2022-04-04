#!/bin/bash -x
vault kv get -output-curl-string secret/hello
