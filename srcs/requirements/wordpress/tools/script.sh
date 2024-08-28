#!/bin/bash

# Vérification des variables d'environnement
if [[ -z "$WP_ADMIN_USER" ]]; then echo "Erreur : WP_ADMIN_USER n'est pas défini."; exit 1; fi
if [[ -z "$WP_ADMIN_PASSWORD" ]]; then echo "Erreur : WP_ADMIN_PASSWORD n'est pas défini."; exit 1; fi
if [[ -z "$WP_ADMIN_EMAIL" ]]; then echo "Erreur : WP_ADMIN_EMAIL n'est pas défini."; exit 1; fi
if [[ -z "$WP_DATABASE" ]]; then echo "Erreur : WP_DATABASE n'est pas défini."; exit 1; fi
if [[ -z "$WP_DB_USER" ]]; then echo "Erreur : WP_DB_USER n'est pas défini."; exit 1; fi
if [[ -z "$WP_DB_PASSWORD" ]]; then echo "Erreur : WP_DB_PASSWORD n'est pas défini."; exit 1; fi
if [[ -z "$WP_URL" ]]; then echo "Erreur : WP_URL n'est pas défini."; exit 1; fi

# Téléchargement et configuration de WP-CLI
cd /var/www/html
if [[ ! -f wp-cli.phar ]]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# Téléchargement de WordPress
if [[ ! -f wp-config.php ]]; then
    ./wp-cli.phar core download --allow-root
    if [[ $? -ne 0 ]]; then echo "Erreur : Échec du téléchargement de WordPress."; exit 1; fi

    # Création du fichier de configuration wp-config.php
    ./wp-cli.phar config create --dbname=$WP_DATABASE --dbuser=$WP_DB_USER --dbpass=$WP_DB_PASSWORD --dbhost=mariadb --allow-root
    if [[ $? -ne 0 ]]; then echo "Erreur : Échec de la création du fichier wp-config.php."; exit 1; fi

    # Installation de WordPress
    ./wp-cli.phar core install --url=$WP_URL --title=inception --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --allow-root
    if [[ $? -ne 0 ]]; then echo "Erreur : Échec de l'installation de WordPress."; exit 1; fi
else
    echo "WordPress est déjà installé."
fi

# Configuration de Redis dans wp-config.php
./wp-cli.phar config set WP_REDIS_HOST redis --allow-root
./wp-cli.phar config set WP_REDIS_PORT 6379 --raw --allow-root
./wp-cli.phar config set WP_CACHE_KEY_SALT $DOMAIN_NAME --allow-root
./wp-cli.phar config set WP_REDIS_CLIENT phpredis --allow-root

# Vérification si le plugin Redis Object Cache est déjà installé
if ./wp-cli.phar plugin is-installed redis-cache --allow-root; then
    echo "Le plugin Redis Object Cache est déjà installé."
else
    # Installation et activation du plugin Redis Object Cache
    ./wp-cli.phar plugin install redis-cache --activate --allow-root
fi

# Mise à jour de tous les plugins
./wp-cli.phar plugin update --all --allow-root

# Activation du cache Redis
./wp-cli.phar redis enable --allow-root

# Installation et activation de l'extension PHP Redis
apt-get update
apt-get install -y php-redis
phpenmod redis

# # Redémarrage manuel de PHP-FPM
# service php7.4-fpm restart

# # Démarrage de PHP-FPM
php-fpm7.4 -F