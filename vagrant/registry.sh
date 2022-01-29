#!/bin/bash

apt-get update && apt-get install -y docker.io 

mkdir -p /mnt/registry 
mkdir -p /home/vagrant/auth
docker run --entrypoint htpasswd httpd:2 -Bbn reguser regpassword > /home/vagrant/auth/htpasswd

docker run -d  --restart=always  --name registry -v /home/vagrant/auth:/auth -e "REGISTRY_AUTH=htpasswd" -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 -v /home/vagrant/regcerts:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key  -p 443:443  -v /mnt/registry:/var/lib/registry   registry:2

