#!/bin/sh

#Configure grafana
sed s/";domain = localhost/domain = ${IP}" /usr/share/grafana/conf/defaults.ini

# Configure Telegraf
mkdir -p /etc/telegraf
telegraf -sample-config --input-filter cpu:mem:net:swap:diskio --output-filter influxdb > /etc/telegraf/telegraf.conf
sed -i s/'# urls = \["http:\/\/127.0.0.1:8086"\]'/'urls = ["http:\/\/influxdb:8086"]'/ /etc/telegraf/telegraf.conf
sed -i s/'# database = "telegraf"'/'database = "grafana"'/ /etc/telegraf/telegraf.conf
sed -i s/'omit_hostname = false'/'omit_hostname = true'/ /etc/telegraf/telegraf.conf

# Start grafana
grafana-server -homepath=/usr/share/grafana/ &

# Start telegraf
telegraf &

# Naive check runs once a minute if any processes exited
# If a process exited
# Then the container exits with an error
# Otherwise it loops forever, only waking up every minute to do another check
while sleep 60; do
    ps aux |grep grafana-server |grep -q -v grep
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
