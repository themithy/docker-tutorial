#!/bin/bash

mkdir -p ./certs/

# Create CA
openssl req -x509 -new -nodes -days 365 -keyout ./certs/ca.key -out ./certs/ca.crt \
-subj "/C=PL/ST=Mazovia/L=Warsaw/O=Nasz tutorial/CN=Nasz tutorial"

# Create CSR
openssl req -new -nodes -keyout ./certs/local.key -out ./certs/local.csr \
-subj "/C=PL/ST=Mazovia/L=Warsaw/O=Nasz tutorial/CN=localhost"

# Create self-signed cert
#openssl req -x509 -new -nodes -keyout ./certs/local.key -out ./certs/local.crt \
# -subj "/C=PL/ST=Mazovia/L=Warsaw/O=Nasz tutorial/CN=localhost"

# Sign CSR
openssl x509 -req -days 365 -in ./certs/local.csr -CA ./certs/ca.crt -CAkey ./certs/ca.key -CAcreateserial -out ./certs/local.crt

# Verify cert
openssl x509 -in ./certs/local.crt -noout -text

# Cleanup
rm ./certs/local.csr ./.srl
