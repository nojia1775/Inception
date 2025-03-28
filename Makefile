all:
	mkdir -p data data/wordpress data/mysql
	docker-compose --project-directory srcs/ up --build -d

clean:
	docker-compose --project-directory srcs/ down

fclean: clean
	rm -rf data
	docker system prune -af

re: fclean all

.PHONY: all clean fclean re
