FROM debian:11.11

RUN apt-get update && apt-get install -y \
    php7.4-fpm \
    php7.4-mysql \
    curl \
    wget \
    unzip \
    less \
    mariadb-client \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/php && chown -R www-data:www-data /run/php

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

COPY ./tools/entrypoint.sh /tmp/entrypoint.sh
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

WORKDIR /var/www/html

RUN chmod +x /tmp/entrypoint.sh

EXPOSE 9000

ENTRYPOINT [ "/tmp/entrypoint.sh" ]

CMD ["php-fpm7.4", "-F"]
