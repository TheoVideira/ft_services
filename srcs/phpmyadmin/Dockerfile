FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp

# Install nginx and additional packages
RUN apk add --no-cache nginx php7 php7-fpm  php7-opcache \
php7-gd php7-mysqli php7-zlib php7-curl php7-mbstring php7-json \
php7-session php7-bz2 php-zip openssl

# Install phpmyadmin
ARG PHPMA_VERSION="5.0.4"
ARG PHPMA_FILE="phpMyAdmin-${PHPMA_VERSION}-all-languages.tar.gz"

RUN wget https://files.phpmyadmin.net/phpMyAdmin/${PHPMA_VERSION}/${PHPMA_FILE}


COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh
COPY srcs/default.conf  /etc/nginx/conf.d/default.conf


ENTRYPOINT ["/usr/sbin/entrypoint.sh"]