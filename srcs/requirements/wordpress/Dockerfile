# PHP-FPM ve WordPress için Alpine tabanlı imaj kullanılıyor
FROM php:8.0-fpm-alpine

# PHP için gerekli olan extensions'ları yükleyin
RUN apk add --no-cache \
    bash \
    libpng libpng-dev \
    libjpeg-turbo libjpeg-turbo-dev \
    libwebp libwebp-dev \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql

# WordPress’i yükleyin
COPY ./wordpress /var/www/html

# WordPress için doğru dosya izinlerini ayarlayın
RUN chown -R www-data:www-data /var/www/html

# PHP-FPM'i başlatın
CMD ["php-fpm"]
