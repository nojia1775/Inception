all:
	docker-compose --project-directory srcs/ up --build

clean:
	docker-compose --project-directory srcs/ down

fclean:
	docker system prune -af

re: fclean all

.PHONY: all clean fclean re
