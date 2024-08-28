FROM debian:bullseye

RUN apt update
RUN apt upgrade -y
RUN apt install redis-server -y

COPY redis.conf /etc/redis/.

CMD ["redis-server", "/etc/redis/redis.conf"]