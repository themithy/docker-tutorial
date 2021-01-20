#!/bin/bash

mkdir -p ./certs/

openssl req -x509 -nodes -keyout ./certs/local.key -out ./certs/local.crt \
-subj "/C=PL/ST=Mazovia/L=Warsaw/O=Nasz tutorial/CN=localhost"

openssl x509 -in ./certs/local.crt -noout -text

# Create random password
# openssl rand -base64 32
