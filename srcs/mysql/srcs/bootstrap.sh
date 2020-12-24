#!/bin/sh

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
mysql_install_db --user=mysql --datadir=/var/lib/mysql/
sed -i 's/^skip-networking/#&/' /etc/my.cnf.d/mariadb-server.cnf

init_db.sh &

/usr/bin/mysqld_safe --datadir="/var/lib/mysql/"