FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp

# Install mysql packages
RUN apk update && apk add --no-cache mysql mysql-client

# Copy mysql setup and entrypoint
COPY srcs/entrypoint.sh /usr/sbin/entrypoint.sh
COPY srcs/init_db.sh    /usr/sbin/init_db.sh

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]