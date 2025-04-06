all:
	mkdir -p /home/nojia/data /home/nojia/data/wordpress /home/nojia/data/mariadb
	docker-compose --project-directory srcs/ up --build -d

clean:
	docker-compose --project-directory srcs/ down

fclean: clean
	rm -rf /home/nojia/data
	docker system prune -af --volumes
	docker volume rm srcs_mariadb_data srcs_wordpress_data

re: fclean all

.PHONY: all clean fclean re
