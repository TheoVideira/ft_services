FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp

# Install mysql packages
RUN apk add --no-cache mysql mysql-client
RUN apk add --no-cache telegraf --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community

# Copy mysql setup and entrypoint
COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh
COPY srcs/init_db.sh    /usr/sbin/init_db.sh

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]