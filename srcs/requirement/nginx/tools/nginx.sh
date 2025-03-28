#!/bin/bash

if [ -d /var/www/html ]; then
	chmod -R 755 /var/www/html
	find /var/www/html -type f -exec chmod 644 {} \;
fi
exec nginx -g "daemon off;"
