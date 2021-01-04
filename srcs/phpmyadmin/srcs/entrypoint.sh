#!/bin/sh

# phpmyadmin setup
mkdir -p /var/www/phpmyadmin

mv phpMyAdmin-5.0.4-all-languages.tar.gz phpmyadmin.tar.gz
tar xzf phpmyadmin.tar.gz --strip-components=1 -C /var/www/phpmyadmin/

sed s/localhost/$WP_DB_HOST/g /var/www/phpmyadmin/config.sample.inc.php > /var/www/phpmyadmin/config.inc.php

rm phpmyadmin.tar.gz


# Create this directory or change it in configs order to launch nginx
mkdir -p /run/nginx


# Start nginx
nginx
status=$?
if [ $status -ne 0 ];
then
	echo "Failed to start nginx: $status"
	exit $status
fi


# Start php-fpm7
php-fpm7
status=$?
if [ $status -ne 0 ];
then
	echo "Failed to start php-fpm7: $status"
	exit $status
fi


# Naive check runs once a minute if any processes exited
# If a process exited
# Then the container exits with an error
# Otherwise it loops forever, only waking up every minute to do another check
while sleep 60; do
    ps aux |grep nginx |grep -q -v grep
    PROCESS_1_STATUS=$?
    ps aux |grep php-fpm |grep -q -v grep
    PROCESS_2_STATUS=$?
    # If the greps above find anything, they exit with 0 status
    # If they are not both 0, then something is wrong
    if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ];
    then
        echo "One of the processes has already exited."
        exit 1
    fi
done