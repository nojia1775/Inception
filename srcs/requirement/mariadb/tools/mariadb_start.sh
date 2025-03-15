#!/bin/bash

service mysql start;

until mysqladmin ping --silent; do
	echo "En attente que MySQL demarre..."
	sleep 2
done

echo "MySQL est demarre"

#mysql_install_db --user=mysql --ldata=/var/lib/mysql

mysql -e "CREATE DATABASE IF NOT EXISTS $SQL_DATABASE;"
mysql -e "UPDATE mysql.user SET Host='%' WHERE User='root'"
mysql -e "CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}'";
mysql -u root -e "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;"
mysql -u root -e "GRANT ALL PRIVILEGES ON ${SQL_DATABASE}.* TO '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}'; FLUSH PRIVILEGES;"
#mysql -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE User='root';"
#mysql -u root -p$SQL_ROOT_PASSWORD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
#mysql -u root -p$SQL_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown
exec mysqld_safe
