#!/bin/sh

until mysql
do
	sleep 0.5
done

mysql -u root -e "DROP DATABASE test;"
mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;"
mysql -u root -e "GRANT ALL ON *.* TO '${MYSQL_ADMIN}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWD}' WITH GRANT OPTION;"
mysql -u root -e "GRANT ALL ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWD}' WITH GRANT OPTION;"