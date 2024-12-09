FROM debian:bullseye

# Sistemi güncelle ve gerekli paketleri yükle
RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    wget \
    tar \
    gnupg \
    less \
    vim \
    lsb-release \
    apt-transport-https \
    && rm -rf /var/lib/apt/lists/*

# PHP deposunu ekleyelim (opsiyonel, gerekirse)
# RUN echo "deb http://deb.debian.org/debian bullseye main" > /etc/apt/sources.list.d/bullseye.list

RUN apt-get update && apt-get install -y \
    php-fpm \
    php-mysql \
    php-curl \
    php-gd \
    php-xml \
    php-mbstring \
    php-zip \
    php-intl \
    php-soap \
    php-imagick \
    php-json \
    php-xmlrpc \
    && rm -rf /var/lib/apt/lists/*

# PHP-FPM için bazı ayarlar
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/*/fpm/php.ini
RUN sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/*/fpm/pool.d/www.conf
RUN mkdir -p /run/php

# WordPress'i indirip kur
ENV WORDPRESS_VERSION 6.3.1
ENV WORDPRESS_SHA1 d61b38bea847d5dc9e20e53f8df86a94cc3dab8e

WORKDIR /var/www/html

COPY ./wordpress /var/www/html

RUN chown -R www-data:www-data /var/www/html

# Ortam değişkenleri ile veritabanı bilgilerini ayarlayabilme
ENV WORDPRESS_DB_HOST=mariadb:3306
ENV WORDPRESS_DB_USER=wordpress
ENV WORDPRESS_DB_PASSWORD=wordpress
ENV WORDPRESS_DB_NAME=wordpress

# İlgili wp-config dosyası oluşturmak için basit bir script (opsiyonel)
# Bu script, container ilk çalıştığında eğer wp-config yoksa otomatik oluşturur.
RUN touch /usr/local/bin/docker-entrypoint.sh && chmod +x /usr/local/bin/docker-entrypoint.sh

# docker-entrypoint.sh örneği
# Bu basit örnek, eğer bir wp-config.php yoksa ortam değişkenlerinden yararlanarak oluşturur.
# Gelişmiş konfigürasyon için farklı bir yöntem izleyebilirsiniz.
RUN printf '#!/usr/bin/env bash\n\
set -e\n\
if [ ! -f /var/www/html/wp-config.php ]; then\n\
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php\n\
    sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php\n\
    sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php\n\
    sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php\n\
    sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php\n\
fi\n\
exec "$@"' > /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]
