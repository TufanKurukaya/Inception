#!/bin/bash

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Wordpress is preparing..."

	wp core download --allow-root

	wp config create --allow-root --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=mariadb

	wp core install --allow-root \
		--url=$DOMAIN_NAME \
		--title="wordpress" \
		--admin_user=$WP_ADMIN_NAME \
		--admin_password=$MYSQL_PASSWORD \
		--admin_email=$EMAIL

	wp user create --allow-root \
		$MYSQL_USER "asd@asd.com" \
		--user_pass=$MYSQL_PASSWORD

fi
exec "$@"