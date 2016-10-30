# create all mysql neccessary database
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  mysql_install_db
fi

# init app db
echo "Waiting for MySQL to start..."
until mysqladmin ping &>/dev/null; do
  echo -n "."; sleep 0.2
done

echo "Creating Database"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DB_NAME};"
echo "Setting up Tables"
mysql -u $MYSQL_USERNAME -p$MYSQL_PASSWORD $MYSQL_DB_NAME < /tmp/db_init.sql

echo "Setting up ENV VARS for app"
echo "define('DB_NAME', '${MYSQL_DB_NAME}');" >> /var/www/src/db-connect.php
echo "define('DB_USER', '${MYSQL_DB_USER}');" >> /var/www/src/db-connect.php
echo "define('DB_PASSWORD', '${MYSQL_DB_PASSWORD}');" >> /var/www/src/db-connect.php
echo "define('DB_HOST', '${MYSQL_DB_NAME}');" >> /var/www/src/db-connect.php


/usr/sbin/apache2 -D FOREGROUND