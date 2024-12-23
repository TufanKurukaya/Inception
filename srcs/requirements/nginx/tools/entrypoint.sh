#!/bin/bash

echo "SSL sertifikası oluşturuluyor..."

mkdir -p /etc/ssl/certs /etc/ssl/private

# sed -i "s|!DOMAIN!|$DOMAIN_NAME|g" /etc/nginx/nginx.conf

openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout /etc/ssl/private/nginx.key \
    -out /etc/ssl/certs/nginx.crt \
    -subj "/C=TR/ST=Istanbul/L=Istanbul/O=Inception/CN=$DOMAIN_NAME"

echo "SSL sertifikası /etc/ssl/ dizinine oluşturuldu!"

exec "$@"
