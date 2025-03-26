#!/bin/sh

#if [[ "${$WP_ADMIN}" =~ .*admin.* ]]; then
#	echo "Error: Admin name cannot contains 'admin'"
#	exit 1
#fi

mkdir -p /run/php
chown -R www-data:www-data /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	if [ -f /var/www/html/index.php ] && [ ! -f /var/www/html/wp-config.php ]; then
		rm -rf /var/www/html/*
	fi
	max_tries=60
	count=0
	while ! ping -c 1 mariadb &>/dev/null; do
		sleep 5
		count=$((count+1))
		if [ $count -ge 30 ]; then
			break
		fi
	done
	count=0
	while ! mariadb -h mariadb -u${SQL_USER} -p${SQL_PASSWORD} -e "SHOW DATABASES;" 2>/dev/null; do
		count=$((count+1))
		if [ $count -ge $max_tries ]; then
			if mariadb -h mariadb -u root -p${SQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE}; GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%'; FLUSH PRIVILEGES;" 2>/dev/null; then
				break
			else
				sleep 10
				count=$((count-10))
			fi
		fi
		sleep 5
	done
	cd /var/www/html
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
	find /var/www/html -type f -exec chmod 644 {} \;
fi
exec php-fpm7.3 -F
