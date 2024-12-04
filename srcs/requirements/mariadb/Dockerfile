# Alpine Linux'un son sürümünü base image olarak kullan
FROM alpine:latest

# Gerekli paketleri ve MariaDB'yi yükle
RUN apk update && apk add --no-cache \
    mariadb mariadb-client \
    && rm -rf /var/cache/apk/*

# Veritabanı tablolarını oluştur
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# MariaDB için yapılandırma dosyalarını oluştur
RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld

# MariaDB'yi başlatacak komut
CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql", "--skip-networking=0", "--bind-address=0.0.0.0"]

# Veritabanının dışarıya açılacak portu
EXPOSE 3306
