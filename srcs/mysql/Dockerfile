FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp


# Install mysql packages
RUN apk update && apk add --no-cache mysql mysql-client supervisor


# Setting variables
ARG DB_NAME=wordpress_db
ARG DB_USER=wordpress_user
ARG DB_PASS=wordpress_pass


# Initialise mysql
RUN mkdir -p /run/mysqld
RUN chown -R mysql:mysql /run/mysqld
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql/
RUN sed -i 's/^skip-networking/#&/' /etc/my.cnf.d/mariadb-server.cnf

# Set up database and users
RUN /usr/bin/mysqld_safe --datadir="/var/lib/mysql/" & sleep 2.0                                            && \
    mysql -u root -e "DROP DATABASE test;"                                                                  && \
    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;" && \
    mysql -u root -e "GRANT ALL ON ${DB_NAME}.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}' WITH GRANT OPTION;"


ADD srcs/supervisord.conf   /etc/

CMD ["/usr/bin/supervisord"]