FROM debian:buster

RUN apt update -y
RUN apt install nginx -y
RUN apt install vim -y
RUN apt install curl -y

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/0=42/OU=42/login.42.fr/UID=login"

RUN mkdir -p /var/run/nginx

RUN apt install php-fpm -y

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY ./index.php /var/www/html

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh
