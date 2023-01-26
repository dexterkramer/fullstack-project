.PHONY: status logs start stop clean

status: ## Get status of containers
	docker-compose ps

logs: ## Get logs of containers
	docker-compose logs --tail=0 --follow

start:build ## Build and start docker containers
	docker-compose up -d

dev: 
	make loadLocalizedImage
	make LoadLocalizedImageNpm
	docker-compose up -d
	make log

log: 
	docker-compose logs --tail=10000 -f

destroy:
	docker-compose stop
	docker-compose down -v --remove-orphans
	docker system prune -a --volumes -f

prune: 
	docker system prune -a --volumes -f

stop-all:
	docker stop $(docker ps -aq) && docker rm $(docker ps -aq)

stop: ## Stop docker containers
	docker-compose stop

clean:stop ## Stop docker containers, clean data and workspace
	docker-compose down -v --remove-orphans

addUserToDockerGroup:
	sudo usermod -aG docker $USER
	newgrp docker

kafka-source:
	curl -X POST http://localhost:8083/connectors   -H 'Content-Type:application/json'   -H 'Accept:application/json'   -d @contrib.source.avro.neo4j.json