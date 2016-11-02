FROM ubuntu:12.04

# Install dependencies
RUN apt-get update -y
RUN apt-get install -y bash git curl apache2 php5 libapache2-mod-php5 php5-mcrypt php5-mysql mysql-server \
    && update-rc.d mysql defaults \
    && start mysql 

# Install composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/bin/composer

# Install app
ADD . /var/www
RUN  cd /var/www && /usr/bin/composer install

# Configure apache
RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www
ADD apache.conf /etc/apache2/sites-available/default
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV MYSQL_DB_NAME urler
ENV MYSQL_USERNAME root
ENV MYSQL_PASSWORD root
ENV MYSQL_HOSTNAME localhost

EXPOSE 80
EXPOSE 3306

CMD ["/var/www/init.sh"]
