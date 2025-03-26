all:
	docker-compose --project-directory srcs/ up --build -d

clean:
	docker-compose --project-directory srcs/ down

fclean: clean
	docker system prune -af

re: fclean all

.PHONY: all clean fclean re
