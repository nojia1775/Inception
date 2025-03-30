#!/bin/bash

if [ -d /var/www/html ]; then
	chmod -R 755 /var/www/html
	find /var/www/html -type f -exec chmod 644 {} \;
fi

while [ ! -f /var/www/html/index.php ]; do
	echo "waiting for wordpress to finish"
	sleep 2
done

exec nginx -g "daemon off;"
