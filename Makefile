COMPOSE_DIR := ./srcs

all: up

up:
	@echo "Başlatılıyor..."
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml up -d --build

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
	@echo "Konteynerler ve imajlar tamamen temizleniyor..."
	docker compose -f $(COMPOSE_DIR)/docker-compose.yml down --rmi all --volumes --remove-orphans

re: fclean all

.PHONY: all up down restart build clean fclean re
