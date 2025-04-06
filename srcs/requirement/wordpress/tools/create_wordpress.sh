#!/bin/sh

#if [ "${$WP_ADMIN}" =~ .*admin.* ]; then
#	echo "Error: Admin name cannot contains 'admin'"
#	exit 1
#fi

mkdir -p /run/php
chown -R www-data:www-data /var/www/html

if [ ! -f /var/www/html/wp-config.php ]; then
	rm -rf /var/www/html/*
	max_tries=60
	count=0
	while ! ping -c 1 mariadb &>/dev/null; do
    	    echo "MariaDB server is not reachable yet..."
    	    sleep 5
    	    counter=$((counter+1))
    	    if [ $counter -ge 30 ]; then
    	        echo "MariaDB server is still not reachable after $counter attempts. Continuing anyway..."
    	        break
    	    fi
    	done
	
    	# Then try to connect to the database
    	counter=0
    	while ! mariadb -h mariadb -u$SQL_USER -p$SQL_PASSWORD -e "SHOW DATABASES;" 2>/dev/null; do
    	    counter=$((counter+1))
    	    if [ $counter -ge $max_tries ]; then
    	        echo "Failed to connect to MariaDB after $max_tries attempts. Trying with root..."
    	        # Try with root user as fallback
    	        if mariadb -h mariadb -u root -p$SQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE; GRANT ALL ON $SQL_DATABASE.* TO '$SQL_USER'@'%'; FLUSH PRIVILEGES;" 2>/dev/null; then
    	            echo "Database created with root user."
    	            break
    	        else
    	            echo "Will retry in a few seconds..."
    	            sleep 10
    	            counter=$((counter-10))
    	        fi
    	    fi
    	    echo "MariaDB is not ready yet, waiting... Attempt $counter/$max_tries"
    	    sleep 5
    	done
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
	#while ! ping -c 1 mariadb &>/dev/null; do
	#	sleep 5
	#	count=$((count+1))
	#	if [ $count -ge 30 ]; then
	#		break
	#	fi
	#done
	#count=0
	#while ! mariadb -h mariadb -u${SQL_USER} -p${SQL_PASSWORD} -e "SHOW DATABASES;" 2>/dev/null; do
	#	count=$((count+1))
	#	if [ $count -ge $max_tries ]; then
	#		if mariadb -h mariadb -u root -p${SQL_ROOT_PASSWORD} -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE}; GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%'; FLUSH PRIVILEGES;" 2>/dev/null; then
	#			break
	#		else
	#			sleep 10
	#			count=$((count-10))
	#		fi
	#	fi
	#	sleep 5
	#done
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
