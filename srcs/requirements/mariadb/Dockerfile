FROM alpine:3.20.3

RUN	apk update && apk upgrade && apk add --no-cache \
        mariadb \
        mariadb-client

COPY tools/entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/tmp/entrypoint.sh"]

CMD ["/usr/bin/mysqld", "--user=mysql"]
