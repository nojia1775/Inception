#!/bin/sh

if [ -f ./wp-config.php ]
then
	echo "wordpress already download"
else
	wget http://wordpress.org/latest.tar.gz
	tar -xf latest.tar.gz
	mv wordpress/* .
	rm -rf wordpress latest.tar.gz
	sed -i "s/username_here/$SQL_USER/g" wp-config-sample.php
	sed -i "s/password_here/$SQL_PASSWORD/g" wp-config-sample.php
	sed -i "s/localhost/$SQL_HOSTNAME/g" wp-config-sample.php
	sed -i "s/database_name_here/$SQL_DATABASE/g" wp-config-sample.php
	cp wp-config-sample.php wp-config.php
fi
exec php-fpm7.3 -F
exec $@
