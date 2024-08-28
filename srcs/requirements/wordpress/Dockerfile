FROM debian:bullseye

RUN apt update
RUN apt upgrade -y
RUN apt install php7.4-fpm -y
RUN apt install php-mysqli -y 
RUN apt install curl -y
RUN apt install iputils-ping -y
RUN apt-get install -y redis-tools

RUN mkdir -p /run/php/

COPY /conf/www.conf /etc/php/7.4/fpm/pool.d/.
COPY /tools/script.sh .
RUN chmod +x script.sh

CMD ["./script.sh"]