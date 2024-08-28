#!/bin/sh

# Initialiser la base de données
mysql_install_db --user=mysql --ldata=/var/lib/mysql

# Démarrer le serveur MySQL
mysqld --user=mysql --datadir=/var/lib/mysql &

# Attendre que MySQL soit prêt
while ! mysqladmin ping --silent; do
    echo "Waiting for MySQL to be ready..."
    sleep 2
done

# Exécuter les commandes SQL
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${WP_DB_USER}\`@'localhost' IDENTIFIED BY '${WP_DB_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${WP_ADMIN_USER}\`@'%' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';"
# mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_ADMIN_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Arrêter le serveur MySQL
mysqladmin -u root -p"${WP_ADMIN_PASSWORD}" shutdown

# Redémarrer le serveur MySQL en mode sécurisé
exec mysqld_safe --datadir=/var/lib/mysql