all:
	mkdir -p /home/nadjemia42/data /home/nadjemia42/data/wordpress /home/nadjemia42/data/mariadb
	docker-compose --project-directory srcs/ up --build -d

clean:
	docker-compose --project-directory srcs/ down

fclean: clean
	rm -rf /home/nadjemia42/data
	docker system prune -af --volumes
	docker volume rm srcs_mariadb_data srcs_wordpress_data

re: fclean all

.PHONY: all clean fclean re
