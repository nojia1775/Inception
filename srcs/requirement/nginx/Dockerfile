FROM debian:bullseye

RUN apt-get update -y
RUN apt-get install nginx -y

##DEBUG A SUPPRIMER#####
RUN apt-get install vim -y
RUN apt-get install curl -y
########################

RUN service nginx restart

RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=FR/ST=IDF/L=Paris/0=42/OU=42/login.42.fr/UID=login"

RUN mkdir -p /var/run/nginx

COPY conf/main.conf /etc/nginx/nginx.conf
COPY conf/nginx.conf /etc/nginx/conf.d/nginx.conf

RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]
