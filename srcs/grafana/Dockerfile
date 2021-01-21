FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp


RUN apk add --no-cache grafana telegraf --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community


COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]
