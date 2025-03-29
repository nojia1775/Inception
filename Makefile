all:
	mkdir -p data data/wordpress data/mysql
	docker-compose --project-directory srcs/ up --build -d

clean:
	docker-compose --project-directory srcs/ down

fclean: clean
	rm -rf data
	docker system prune -af
	docker volume rm srcs_mariadb_data srcs_wordpress_data

re: fclean all

.PHONY: all clean fclean re
