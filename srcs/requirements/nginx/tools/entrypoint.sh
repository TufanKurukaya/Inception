#!/bin/bash

mkdir -p /etc/ssl/certs /etc/ssl/private
if [ -f "/run/secrets/credentials" ]; then
    TMP=$(grep SUBJECT /run/secrets/credentials)
    export SUBJECT=${TMP#*=}
    export KEY=$(grep KEY /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
    export CRT=$(grep CRT /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
fi

if [ -z "$SUBJECT" ] || [ -z "$KEY" ] || [ -z "$CRT" ]; then
    echo "Missing required secrets"
    exit 1
fi
sed -i "s|!DOMAIN!|$DOMAIN_NAME|g" /etc/nginx/nginx.conf
sed -i "s|!CRT!|$CRT|g" /etc/nginx/nginx.conf
sed -i "s|!KEY!|$KEY|g" /etc/nginx/nginx.conf

echo "SSL sertifikası oluşturuluyor..."

if [ -f "$CRT" ] && [ -f "$KEY" ]; then
    echo "SSL sertifikası zaten var!"
    exec "$@"
fi

openssl req -x509 -nodes -days 365 -newkey rsa:4096 \
    -keyout "$KEY" \
    -out $CRT \
    -subj "$SUBJECT"

echo "SSL sertifikası oluşturuldu!"

exec "$@"
