FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    curl \
    php \
    php-cli \
    php-mysqli \
    php-pdo \
    php-pdo-mysql \
    && rm -rf /var/lib/apt/lists/*

RUN curl -L -O https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php
RUN mkdir -p /var/www/html
RUN mv ./adminer-4.8.1.php /var/www/html/index.php

# Exposer le port 8081
EXPOSE 8081

# Utiliser le serveur intégré de PHP pour servir Adminer
CMD ["php", "-S", "0.0.0.0:8081", "-t", "/var/www/html/"]
