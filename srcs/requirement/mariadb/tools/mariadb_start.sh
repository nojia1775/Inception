#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysqld --initialize-insecure --user=mysql --datadir=/var/lib/mysql
	/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

	until mysqladmin ping > /dev/null 2>&1; do
		echo waiting for mariadb
		sleep 2
	done
	mysql -u root -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
	mysql -u root -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
	mysql -u root -e" GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
	mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"
	mysql -u root -e "FLUSH PRIVILEGES;"
	mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown;
else
	/usr/bin/mysqld_safe --datadir=/var/lib/mysql &

	until mysqladmin ping >/dev/null 2>&1; do
		sleep 2
	done
	mysql -uroot -p${SQL_ROOT_PASSWORD} -e "SELECT User FROM mysql.user WHERE User='$SQL_USER'" | grep -q $SQL_USER
	USER_EXISTS=$?

	if [ $USER_EXISTS -ne 0 ]; then
		mysql -uroot -p$SQL_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS ${SQL_DATABASE};"
		mysql -uroot -p$SQL_ROOT_PASSWORD -e "CREATE USER IF NOT EXISTS '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"
		mysql -uroot -p$SQL_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%';"
		mysql -uroot -p$SQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
	fi
	mysqladmin -uroot -p$SQL_ROOT_PASSWORD shutdown
fi
exec mysqld --user=mysql