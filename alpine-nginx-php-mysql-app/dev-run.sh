docker build -t alpine-nginx-php-mysql-app .

docker run -d \
  --name nginx-php-mysql \
  -p 80:80 \
  -v $PWD/data:/var/lib/mysql \
  -v $PWD/logs:/data/logs \
  -v $PWD:/data/htdocs \
  alpine-nginx-php-mysql-app