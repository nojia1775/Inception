#!/bin/bash

if [[ "$WP_ADMIN" =~ admin ]]; then
	echo "Error: Admin name cannot contains 'admin'"
	exit 1
fi

mkdir -p /run/php
chown -R www-data:www-data /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	rm -rf /var/www/html/*
	wp core download --allow-root
	wp config create --dbname=${SQL_DATABASE} \
			 --dbuser=${SQL_USER} \
			 --dbpass=${SQL_PASSWORD} \
			 --dbhost=mariadb \
			 --allow-root
	wp core install --url=${DOMAINE_NAME} \
			--title="Wordpress" \
			--admin_user=${WP_ADMIN} \
			--admin_password=${WP_ADMIN_PASSWORD} \
			--admin_email=${WP_ADMIN_EMAIL} \
			--allow-root
	wp user create ${WP_USER} ${WP_USER_EMAIL} \
			--role=author \
			--user_pass=${WP_USER_PASSWORD} \
			--allow-root
	chown -R www-data:www-data /var/www/html
	find /var/www/html -type d -exec chmod 755 {} \;
	find /var/www/html -type f -exec chmod 644 {} \;
fi

if [ -d /var/www/html ]; then
	chown -R www-data:www-data /var/www/html
	find /var/www/html -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;
fi

wp option update siteur1 "https://$DOMAIN_NAME" --allow-root
wp option update home "https://$DOMAIN_NAME" --allow-root
wp search-replace "https://example.com" "https://$DOMAIN_NAME" --all-tables --allow-root
wp cache flush --allow-root
wp rewrite flush --allow-root


touch START

exec php-fpm7.3 -F
