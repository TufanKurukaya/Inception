#!/bin/bash

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

if [ -f "/run/secrets/db_password" ]; then
	MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f "/run/secrets/credentials" ]; then
	export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export MYSQL_DATABASE=$(grep MYSQL_DATABASE /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export ADMIN_EMAIL=$(grep ADMIN_EMAIL /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export ADMIN_PASSWORD=$(grep ADMIN_PASSWORD /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_ADMIN_NAME=$(grep WP_ADMIN_NAME /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_USER_LOGIN=$(grep WP_USER_LOGIN /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_USER_PASSWORD=$(grep WP_USER_PASSWORD /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_USER_EMAIL=$(grep WP_USER_EMAIL /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export WP_HOST=$(grep WP_HOST /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
fi

if  [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_DATABASE" ] || [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ]\
 || [ -z "$WP_ADMIN_NAME" ] || [ -z "$WP_USER_LOGIN" ] || [ -z "$WP_USER_PASSWORD" ] || [ -z "$WP_USER_EMAIL" ] || [ -z "$WP_HOST" ]; then
	echo "Missing required secrets"
	exit 1
fi


if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Wordpress is preparing..."
max=4
counter=0
	wp core download --allow-root

	until wp config create --allow-root \
		--dbname="$MYSQL_DATABASE" \
		--dbuser="$MYSQL_USER" \
		--dbpass="$MYSQL_PASSWORD" \
		--dbhost="$WP_HOST"
	do
		if [ $counter -eq $max ]; then
			echo "wp-config.php oluşturulamadı. Çıkılıyor..."
			exit 1
		fi
		counter=$((counter+1))
		echo "wp-config.php oluşturulamadı. 5 saniye sonra yeniden denenecek..."
		sleep 5
	done

	wp core install --allow-root \
		--url="$DOMAIN_NAME" \
		--title="$TITLE" \
		--admin_user="$WP_ADMIN_NAME" \
		--admin_password="$ADMIN_PASSWORD" \
		--admin_email="$ADMIN_EMAIL"
	wp user create --allow-root \
		$WP_USER_LOGIN $WP_USER_EMAIL \
		--user_pass=$WP_USER_PASSWORD

fi

exec "$@"
