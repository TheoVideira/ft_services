FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp

RUN apk update && apk add --no-cache openssl vsftpd

COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh
COPY srcs/vsftpd.conf   /etc/vsftpd/vsftpd.conf


ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
