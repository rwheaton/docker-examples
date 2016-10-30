#!/bin/bash

# create all mysql neccessary database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  mysql_install_db
fi

echo "Updating creds"
mysqladmin password ${MYSQL_USERNAME} ${MYSQL_PASSWORD}

# start mysql
/usr/sbin/mysqld --skip-grant-tables &

# init app db
echo "Waiting for MySQL to start..."
until mysqladmin ping &>/dev/null; do
  echo -n "."; sleep 0.2
done

echo "Updating creds"
mysqladmin password ${MYSQL_USERNAME} ${MYSQL_PASSWORD}
echo "Creating Database"
mysql -h ${MYSQL_HOSTNAME} -u ${MYSQL_USERNAME} -p${MYSQL_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};"
echo "Setting up Tables"
mysql -h ${MYSQL_HOSTNAME} -u ${MYSQL_USERNAME} -p${MYSQL_PASSWORD} ${MYSQL_DB_NAME} < /var/www/db_init.sql

echo "Setting up ENV VARS for app"
echo "define('DB_NAME', '${MYSQL_DB_NAME}');" >> /var/www/src/db-connect.php
echo "define('DB_USER', '${MYSQL_USER}');" >> /var/www/src/db-connect.php
echo "define('DB_PASSWORD', '${MYSQL_PASSWORD}');" >> /var/www/src/db-connect.php
echo "define('DB_HOST', '${MYSQL_HOSTNAME}');" >> /var/www/src/db-connect.php


exec /usr/sbin/apache2 -D FOREGROUND
