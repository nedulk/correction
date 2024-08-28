FROM debian:bullseye

# Installer vsftpd
RUN apt update && apt upgrade -y && apt install -y vsftpd

# Copier le fichier de configuration vsftpd.conf
COPY vsftpd.conf /etc/vsftpd/.

# Créer le répertoire nécessaire pour vsftpd
RUN mkdir -p /var/run/vsftpd/empty

# Créer l'utilisateur FTP et son répertoire
RUN useradd -m ftpUser && echo "ftpUser:ftpftp" | chpasswd

# Créer le répertoire /var/www/html et modifier ses permissions
RUN mkdir -p /var/www/html
RUN usermod -d /var/www/html ftpUser
RUN chmod a-w /var/www/html

# Copier le script et lui donner les permissions d'exécution
COPY script.sh .
RUN chmod +x script.sh

# Démarrer vsftpd
CMD ["./script.sh"]