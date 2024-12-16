FROM alpine:3.20.3

RUN apk update && apk add --no-cache nginx openssl bash

RUN mkdir -p /etc/nginx/ssl /var/www/html

COPY ./conf/nginx.conf /etc/nginx/nginx.conf
COPY ./tools/generate_ssl.sh /etc/nginx/ssl/generate_ssl.sh

RUN chmod +x /etc/nginx/ssl/generate_ssl.sh

EXPOSE 443

ENTRYPOINT [ "etc/nginx/ssl/generate_ssl.sh" ]

CMD ["nginx", "-g", "daemon off;"]

