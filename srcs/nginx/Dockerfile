FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp

RUN apk update && apk add --no-cache nginx openssl

RUN mkdir -p /var/www/html;

ENV IP=127.0.0.1
ENV WPPORT=5050
ENV PMAPORT=5000

COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh
COPY srcs/default.conf  /etc/nginx/conf.d/default.conf
COPY srcs/index.html    /var/www/html/index.html


ENTRYPOINT ["/usr/sbin/entrypoint.sh"]