FROM alpine:3.20.3

RUN	apk update && apk upgrade && apk add --no-cache \
        mariadb \
        mariadb-client

COPY tools/entrypoint.sh /tmp/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["sh", "/tmp/entrypoint.sh"]
