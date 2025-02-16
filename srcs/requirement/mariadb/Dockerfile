FROM alpine:3.21.3

RUN apt-get update
RUN apt-get install mariadb-server -y

EXPOSE 3306

CMD ["mariadbd"]