#!/bin/sh

if [ ! -d /data/htdocs ] ; then
  mkdir -p /data/htdocs
  chown :www-data /data/htdocs
fi

# create all mysql neccessary database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  mysql_install_db
fi

# start mysql
mysqld --skip-grant-tables &

# init app db
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DB_NAME < /tmp/db_init.sql

# start php-fpm
mkdir -p /data/logs/php-fpm
php-fpm

# start nginx
mkdir -p /data/logs/nginx
mkdir -p /data/logs/php-fpm
mkdir -p /tmp/nginx
chown nginx /tmp/nginx
nginx
