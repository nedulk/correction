# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: kprigent <kprigent@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2024/06/17 12:10:05 by kprigent          #+#    #+#              #
#    Updated: 2024/08/05 17:49:30 by kprigent         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Variables
DATA_DIR=/home/kprigent/data
MYSQL_DIR=$(DATA_DIR)/mysql
WORDPRESS_DIR=$(DATA_DIR)/wordpress

# Couleurs
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;93m
BLUE=\033[1;94m
NC=\033[0m # No Color

# Règles
all: setup start

# Création des répertoires nécessaires
setup:
	@echo "${BLUE}Création des répertoires...${NC}"
	@mkdir -p $(MYSQL_DIR) $(WORDPRESS_DIR)
	@echo "${GREEN}Les répertoires ont été créés avec succès.${NC}"

# Suppression des répertoires
clean:
	@echo "${RED}Suppression des répertoires...${NC}"
	@sudo rm -rf $(MYSQL_DIR) $(WORDPRESS_DIR)
	@echo "${GREEN}Les répertoires ont été supprimés avec succès.${NC}"

# Lancer les containers un par un
start:
	@echo "${YELLOW}Lancement des containers...${NC}"
	@docker compose -f srcs/docker-compose.yml up --build -d
	@echo "${GREEN}Containers lancés.${NC}"
	@echo "${YELLOW}"
	@echo "	 _____                      _   _             "
	@echo "        |_   _|                    | | (_)            "
	@echo "          | |  _ __   ___ ___ _ __ | |_ _  ___  _ __  "
	@echo "          | | | '_ \\ / __/ _ \\ '_ \\| __| |/ _ \\| '_ \\ "
	@echo "         _| |_| | | | (_|  __/ |_) | |_| | (_) | | | |"
	@echo "        |_____|_| |_|\\___\\___| .__/ \\__|_|\\___/|_| |_|"
	@echo "                             | |                      "
	@echo "                             |_|                      "
	@echo "${NC}"
	@echo "${BLUE}-> Wordpress website :${NC} https://kprigent.42.fr"
	@echo "${BLUE}-> Static website :${NC} http://kprigent.42.fr:8080"
	@echo "${BLUE}-> Adminer :${NC} http://kprigent.42.fr:8081"
	@echo "${BLUE}-> Prometheus :${NC} http://kprigent.42.fr:9090"

	


# Arrêter les containers
stop:
	@echo "${RED}Arrêt des containers...${NC}"
	@docker compose -f srcs/docker-compose.yml down
	@echo "${GREEN}Containers arrêtés.${NC}"

# Arrêter les containers et nettoyer le système Docker
stopC: clean
	@echo "${RED}Arrêt des containers...${NC}"
	@docker compose -f srcs/docker-compose.yml down
	@echo "${GREEN}Containers arrêtés.${NC}"
	@echo "${RED}Nettoyage du système Docker...${NC}"
	@docker system prune -a -f > /dev/null 2>&1
	@echo "${GREEN}Nettoyage du système Docker terminé.${NC}"

# Recréation complète (nettoyer + tout refaire)
re: stop all

.PHONY: all setup clean start stop stopC re
