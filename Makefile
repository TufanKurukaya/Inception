COMPOSE_DIR := ./srcs

all: up

up:
	@echo "Başlatılıyor..."
	mkdir -p ${HOME}/data/wordpress
	mkdir -p ${HOME}/data/mariadb
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml up --build

down:
	@echo "Durduruluyor..."
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml down

restart: down up

build:
	@echo "Yeniden oluşturuluyor..."
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml build

clean:
	@echo "Geçici dosyalar temizleniyor..."
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml down --volumes --remove-orphans

fclean: clean
	@sudo rm -rf ${HOME}/data
	@echo "Konteynerler ve imajlar tamamen temizleniyor..."
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml down --rmi all --volumes --remove-orphans

re: fclean all

logs:
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml logs -f

f:
	docker builder prune -a --force
	docker system prune -a --volumes --force
	docker volume prune --all --force

c:
	docker rm -f $$(docker ps -a -q)
	docker image rm -f $$(docker image ls -a -q)
	docker volume prune --all --force

nginx:
	docker compose -f srcs/docker-compose.yml up --build nginx

maria:
	docker compose -f srcs/docker-compose.yml up --build mariadb

wordpress:
	docker compose -f srcs/docker-compose.yml up --build wordpress

.PHONY: all up down restart build clean fclean re
