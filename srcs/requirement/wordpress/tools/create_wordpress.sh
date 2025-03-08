#!/bin/sh

if [ -f ./wp-config.php ]
then
	echo "wordpress already download"
else
	wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz -P /var/www
	cd /var/www
	tar -xf wordpress-6.0-fr_FR.tar.gz
	rm -rf wordpress-6.0-fr_FR.tar.gz
	mv wordpress/* .
	sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php
fi
exec php-fpm7.3 -F
#exec "$a"
