VOLUME_DIR=~/data/dockervolumes
COMPOSE_FILE=./srcs/docker-compose.yml

all: wordpress_vol mariadb_vol
	make up

up:
	docker compose -f $(COMPOSE_FILE) up --build -d

down:
	docker compose -f $(COMPOSE_FILE) down

# no need to depend on 'down' when down is the way to remove images anyway
# does work even when the stack is not up
clean: 
	docker compose -f $(COMPOSE_FILE) down --rmi all

fclean: clean
	docker compose -f $(COMPOSE_FILE) down -v
	sudo rm -fr $(VOLUME_DIR)/*

re: fclean
	make all

wordpress_vol:
	mkdir -m 777 -p $(VOLUME_DIR)/wordpress

mariadb_vol:
	mkdir -m 777 -p $(VOLUME_DIR)/mariadb

.PHONY: all up build down clean fclean re wordpress_vol mariadb_vol
