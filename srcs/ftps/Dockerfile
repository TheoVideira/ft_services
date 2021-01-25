FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp

RUN apk add --no-cache openssl vsftpd
RUN apk add --no-cache telegraf --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh
COPY srcs/vsftpd.conf   /etc/vsftpd/vsftpd.conf


ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
