FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server mariadb-client -y
RUN apt install procps -y

RUN mkdir -p /var/run/mysqld && chown mysql:mysql /var/run/mysqld

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf/50-server.cnf

COPY ./tools/mariadb_start.sh ./mariadb_start.sh
RUN chmod 755 mariadb_start.sh

EXPOSE 3306

CMD ["./mariadb_start.sh"]
