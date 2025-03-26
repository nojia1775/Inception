FROM debian:bullseye

RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install mariadb-server mariadb-client -y
RUN apt-get install procps -y

RUN mkdir -p /run/mysqld && chown mysql:mysql /run/mysqld /var/lib/mysql

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools/mariadb_start.sh ./mariadb_start.sh
RUN chmod 755 mariadb_start.sh

EXPOSE 3306

CMD ["./mariadb_start.sh"]
