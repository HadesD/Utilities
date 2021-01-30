# mysql
docker run -d --restart unless-stopped --name mysql --env="MYSQL_ALLOW_EMPTY_PASSWORD=ON" -p 3306:3306 mysql

# php-fpm
docker run -d --restart unless-stopped --name php -p 9000:9000 -v $PWD:/var/www/website php:7.4.14-fpm-alpine3.13

# nginx
docker run -d --restart unless-stopped --name nginx -p 80:80 -v $PWD:/var/www/website nginx
