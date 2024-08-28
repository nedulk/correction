#!/bin/sh

# Vérifier que les variables d'environnement sont définies
if [ -z "$FTP_USER" ]; then echo "FTP_USER is not set"; exit 1; fi
if [ -z "$FTP_PASSWORD" ]; then echo "FTP_PASSWORD is not set"; exit 1; fi

# Créer un utilisateur FTP et définir son mot de passe
useradd -m "$FTP_USER" && echo "$FTP_USER:$FTP_PASSWORD" | chpasswd

# Créer le répertoire FTP et définir les permissions
mkdir -p /home/"$FTP_USER"/ftp && chown nobody:nogroup /home/"$FTP_USER"/ftp && chmod a-w /home/"$FTP_USER"/ftp
mkdir -p /home/"$FTP_USER"/ftp/files && chown "$FTP_USER":"$FTP_USER" /home/"$FTP_USER"/ftp/files

vsftpd /etc/vsftpd/vsftpd.conf