.PHONY: status logs start stop clean

status: ## Get status of containers
	sudo docker-compose ps

logs: ## Get logs of containers
	sudo docker-compose logs --tail=0 --follow

start:build ## Build and start docker containers
	sudo docker-compose up -d

dev: 
	sudo docker-compose up

destroy:
	sudo docker-compose stop
	sudo docker-compose down -v --remove-orphans
	sudo docker system prune -a --volumes -f

prune: 
	sudo docker system prune -a --volumes -f

stop-all:
	sudo docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

stop: ## Stop docker containers
	sudo docker-compose stop

clean:stop ## Stop docker containers, clean data and workspace
	sudo docker-compose down -v --remove-orphans
