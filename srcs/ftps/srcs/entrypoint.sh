#!/bin/sh

# Create ssl certificate
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -subj "/C=FR/ST=75/L=Paris/O=42/CN=tvideira"    \
    -keyout /etc/ssl/private/vsftpd.key   \
    -out /etc/ssl/certs/vsftpd.crt

# Adding user
adduser -D $FTP_USER && echo "$FTP_USER:$FTP_PASSWD" | chpasswd
chown -R $FTP_USER /home/$FTP_USER

# Apply external ip
sed -i s/__IP__/$IP/g /etc/vsftpd/vsftpd.conf

vsftpd /etc/vsftpd/vsftpd.conf