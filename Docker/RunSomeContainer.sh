# mysql
docker run -d --restart unless-stopped --name mysql --env="MYSQL_ALLOW_EMPTY_PASSWORD=ON" -p 3306:3306 -p 33060:33060 mysql

# php-fpm
docker run -d --restart unless-stopped --name php --link=mysql -p 9000:9000 -v $PWD:/var/www/website php:7.4.14-fpm-alpine3.13

# nginx
docker run -d --restart unless-stopped --name nginx --link=php -p 80:80 -v $PWD:/var/www/website -v $PWD/../nginx:/etc/nginx/conf.d nginx
