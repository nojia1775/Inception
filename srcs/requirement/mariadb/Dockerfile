FROM debian:buster

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server mariadb-client -y

COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf/50-server.cnf
COPY ./tools/mariadb_start.sh ./mariadb_start.sh

RUN chmod 755 mariadb_start.sh

CMD ["./mariadb_start.sh"]
