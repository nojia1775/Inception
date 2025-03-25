FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt install wget -y
RUN apt install php7.3 php-fpm php-mysql mariadb-client -y

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./conf/www.conf /etc/php/7.3/fpm/pool.d/

RUN mkdir -p /run/php && chown www-data:www-data /run/php

COPY ./tools/create_wordpress.sh .
RUN chmod +x create_wordpress.sh

WORKDIR /var/www/html

EXPOSE 9000

CMD ["./create_wordpress.sh"]
