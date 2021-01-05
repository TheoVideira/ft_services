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

# Start nginx
nginx -g "daemon off;"
