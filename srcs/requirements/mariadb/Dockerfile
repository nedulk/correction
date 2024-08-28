FROM		debian:bullseye

RUN apt update -y
RUN apt upgrade -y
RUN apt-get install mariadb-server -y
RUN apt install iputils-ping -y

COPY conf/50-server.cnf	/etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/init.sql /etc/mysql/init.sql
COPY tools/script.sh .

RUN mkdir /run/mysqld
RUN chmod 777 script.sh && chmod +x script.sh

CMD ["./script.sh"]