#!/bin/sh

# Create this directory or change it in configs order to launch nginx
mkdir -p /run/nginx

# Create ssl certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=FR/ST=75/L=Paris/O=42/CN=tvideira"    \
    -keyout /etc/ssl/private/nginx-selfsigned.key   \
    -out /etc/ssl/certs/nginx-selfsigned.crt

# Replace IP and ports
sed -i s/__IP__/$IP/g           /etc/nginx/conf.d/default.conf
sed -i s/__WPPORT__/$WPPORT/g   /etc/nginx/conf.d/default.conf
sed -i s/__PMAPORT__/$PMAPORT/g /etc/nginx/conf.d/default.conf

mkdir -p /etc/telegraf
telegraf -sample-config --input-filter cpu:mem --output-filter influxdb > /etc/telegraf/telegraf.conf
sed -i s/'# urls = \["http:\/\/127.0.0.1:8086"\]'/'urls = ["http:\/\/influxdb:8086"]'/ /etc/telegraf/telegraf.conf
sed -i s/'# database = "telegraf"'/'database = "nginx"'/ /etc/telegraf/telegraf.conf
sed -i s/'omit_hostname = false'/'omit_hostname = true'/ /etc/telegraf/telegraf.conf

# Start nginx
nginx

# Start telegraf
telegraf &

# Naive check runs once a minute if any processes exited
# If a process exited
# Then the container exits with an error
# Otherwise it loops forever, only waking up every minute to do another check
while sleep 60; do
    ps aux |grep nginx |grep -q -v grep
    PROCESS_1_STATUS=$?
    ps aux |grep telegraf |grep -q -v grep
    PROCESS_2_STATUS=$?
    # If the greps above find anything, they exit with 0 status
    # If they are not both 0, then something is wrong
    if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 ];
    then
        echo "One of the processes has already exited."
        exit 1
    fi
done
