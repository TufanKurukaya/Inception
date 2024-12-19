FROM alpine:3.20.3

RUN apk update && apk add --no-cache mariadb mariadb-client

COPY ./tools/entrypoint.sh /tmp/entrypoint.sh
COPY ./conf/50-server.cnf /etc/my.cnf.d/50-server.cnf

RUN chmod +x /tmp/entrypoint.sh

EXPOSE 3306

ENTRYPOINT [ "/tmp/entrypoint.sh" ]


CMD ["mysqld_safe", "--user=mysql"]
