#!/bin/bash

export PANOS_HOSTNAME=$(cd terragrunt/resources && terragrunt output -json ip | jq -r '.[]')
go get golang.org/x/crypto/ssh
go build ./panos_init.go
./panos_init palo_key.pem
