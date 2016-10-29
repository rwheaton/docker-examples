FROM alpine:edge

RUN apk add --update curl wget git mysql mysql-client \
  bash nginx ca-certificates \
  php5-fpm php5-json php5-zlib php5-xml php5-pdo php5-phar php5-openssl \
  php5-pdo_mysql php5-mysqli \
  php5-gd php5-iconv php5-mcrypt \
  php5-curl php5-openssl php5-json php5-dom php5-ctype && \
  apk add -u musl && \
  mkdir -p /var/lib/mysql && \
  mkdir -p /etc/mysql/conf.d && \
  mkdir -p /etc/nginx/conf.d && \
  mkdir -p /var/run/mysql/ && \
  curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
  rm -rf /var/cache/apk/*

ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php/
ADD files/my.cnf /etc/mysql/
ADD files/default.conf /etc/nginx/conf.d/
ADD files/db_init.sql /tmp/
ADD files/run-server.sh /
RUN chmod +x /run-server.sh

# Install app
RUN mkdir -p /data/htdocs/web/ && mkdir -p /data/htdocs/src/
ADD composer.json /data/htdocs/
ADD src/ /data/htdocs/src/
ADD web/ /data/htdocs/web/
RUN  cd /data/htdocs && /usr/bin/composer install

EXPOSE 80
EXPOSE 3306

WORKDIR /data/htdocs/
#VOLUME ["/data/htdocs", "/data/logs", "/var/lib/mysql", "/etc/mysql/conf.d/"]
#CMD ["/run-server.sh"]
CMD ["bash"]
