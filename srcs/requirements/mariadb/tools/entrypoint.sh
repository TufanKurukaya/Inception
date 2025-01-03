#!/bin/sh

if [ -f "/run/secrets/db_root_password" ]; then
	MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
fi

if [ -f "/run/secrets/db_password" ]; then
	MYSQL_PASSWORD=$(cat /run/secrets/db_password)
fi

if [ -f "/run/secrets/credentials" ]; then
	export MYSQL_USER=$(grep MYSQL_USER /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
	export MYSQL_DATABASE=$(grep MYSQL_DATABASE /run/secrets/credentials | cut -d '=' -f2 | tr -d '[:space:]')
fi

if [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_DATABASE" ]; then
	echo "Missing required secrets"
	exit 1
fi

if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then

	chown -R mysql:mysql /var/lib/mysql

	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
		return 1
	fi

	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

DELETE FROM	mysql.user WHERE User='';
DROP DATABASE test;
DELETE FROM mysql.db WHERE Db='test';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

CREATE DATABASE $MYSQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER '$MYSQL_USER'@'%' IDENTIFIED by '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

FLUSH PRIVILEGES;
EOF
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile
fi

sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

exec "$@"
