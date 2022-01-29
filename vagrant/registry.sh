#!/bin/bash

apt-get update && apt-get install -y docker.io 

mkdir -p /mnt/registry 

docker run -d  \
    --restart=always \
    --name registry \
    -v "$(pwd)"/certs:/certs \
    -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
    -p 443:443
    -v /mnt/registry:/var/lib/registry \
    registry:2

