#!/bin/sh

set -e

echo "Initializing MariaDB data directory if necessary..."
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
fi

echo "Starting MariaDB server for setup..."
mysqld_safe --user=mysql &
pid="$!"

# Wait until MariaDB is ready to accept connections
echo "Waiting for MariaDB to start..."
while ! mysqladmin ping -h "localhost" --silent; do
    sleep 1
done

echo "MariaDB started. Setting up database and user..."

# Read secrets
DB_USER=$MYSQL_USER
DB_PASS=$MYSQL_PASSWORD

# Ensure environment variables are set
if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "MYSQL_ROOT_PASSWORD is not set. Exiting."
    exit 1
fi

# Create database
if [ -n "$MYSQL_DATABASE" ]; then
    echo "Creating database: $MYSQL_DATABASE"
    mysql -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;"
fi

# Create user and grant privileges for '%'
if [ -n "$DB_USER" ] && [ -n "$DB_PASS" ]; then
    echo "Creating user: $DB_USER@'%'"
    mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PASS';"
    echo "Granting privileges to user: $DB_USER@'%' on database: $MYSQL_DATABASE"
    mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-}\`.* TO '$DB_USER'@'%';"
    mysql -e "FLUSH PRIVILEGES;"
fi

# Optionally, create user for 'localhost'
echo "Creating user: $DB_USER@'localhost'"
mysql -e "CREATE USER IF NOT EXISTS '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASS';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE:-}\`.* TO '$DB_USER'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

echo "Shutting down MariaDB server after setup..."
mysqladmin shutdown

echo "MariaDB setup complete."

# Start MariaDB in the foreground
exec "$@"
