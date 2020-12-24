FROM alpine:3.12.0

LABEL maintainer="Théo Videira (tvideira@student.42.fr)"

WORKDIR /tmp


# Install mysql packages
RUN apk update && apk add --no-cache mysql mysql-client supervisor


# Setting variables (ARG are in yaml)
#ARG WP_DB_NAME=wordpress_db
#ARG WP_DB_USER=wordpress_user
#ARG WP_DB_PASSWD=wordpress_pass
#ARG MYSQL_ADMIN=admin
#ARG MYSQL_ADMIN_PASSWD=admin01

# Initialise mysql
#RUN echo ${WP_DB_NAME} ${WP_DB_USER} ${WP_DB_PASSWD} ${MYSQL_ADMIN} ${MYSQL_ADMIN_PASSWD} MABITE
#RUN mkdir -p /run/mysqld
#RUN chown -R mysql:mysql /run/mysqld
#RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql/
#RUN sed -i 's/^skip-networking/#&/' /etc/my.cnf.d/mariadb-server.cnf

# Set up database and users
#RUN /usr/bin/mysqld_safe --datadir="/var/lib/mysql/" & sleep 2.0                                                            && \
#    mysql -u root -e "DROP DATABASE test;"                                                                                  && \
#    mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${WP_DB_NAME} CHARACTER SET utf8 COLLATE utf8_general_ci;"              && \
#    mysql -u root -e "GRANT ALL ON *.* TO '${MYSQL_ADMIN}'@'%' IDENTIFIED BY '${MYSQL_ADMIN_PASSWD}' WITH GRANT OPTION;"    && \
#    mysql -u root -e "GRANT ALL ON ${WP_DB_NAME}.* TO '${WP_DB_USER}'@'%' IDENTIFIED BY '${WP_DB_PASSWD}' WITH GRANT OPTION;"


COPY srcs/bootstrap.sh   /usr/sbin/bootstrap.sh
COPY srcs/init_db.sh     /usr/sbin/init_db.sh

ENTRYPOINT ["/usr/sbin/bootstrap.sh"]