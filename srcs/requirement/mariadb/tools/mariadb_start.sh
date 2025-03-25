#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
	/usr/bin/mysqld_safe --datadir=/var/lib/mysql &
	until mysqladmin ping > /dev/null 2>&1; do
		sleep 2
	done
	mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;
CREATE USER IF NOT EXISTS '{$SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
	mysqladmin -u root -p${SQL_ROOT_PASSWORD} shutdown;
else
	/usr/bin/mysqld_safe --datadir=/var/lib/mysql &
	until mysqladmin ping >/dev/null 2>&1; do
		sleep 2
	done
	mysql -uroot -p${SQL_ROOT_PASSWORD} -e "SELECT User FROM mysql.user WHERE User='${SQL_USER}'" | grep -q ${SQL_USER}
	USER_EXISTS=$?

	if [ USER_EXISTS -ne 0 ]; then
		mysql -uroot -p${SQL_ROOT_PASSWORD} <<EOF
	CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};
	CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
	GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%';
	FLUSH PRIVILEGES;
	EOF
		fi
	mysqladmin -uroot -p${SQL_ROOT_PASSWORD} shutdown
fi
exec mysqld --user=mysql
