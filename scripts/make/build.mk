.PHONY: build build-prod

build: ## Build docker image
	docker-compose build

build-prod: ## Build docker image (production)
	docker-compose -f docker-compose.prod.yml build

localizeAfterNpm:
	docker save my_api:latest > images/my_api.tar
	docker save my_client:latest > images/my_client.tar

localizeImage:
	docker pull postgres
	docker save postgres > images/postgres.tar
	docker pull quay.io/keycloak/keycloak:19.0.1
	docker save quay.io/keycloak/keycloak:19.0.1 > images/keycloak.19.0.1.tar
	docker pull confluentinc/cp-zookeeper
	docker save confluentinc/cp-zookeeper > images/cp-zookeeper.tar
	docker pull confluentinc/cp-kafka
	docker save confluentinc/cp-kafka > images/cp-kafka.tar
	docker pull confluentinc/cp-schema-registry
	docker save confluentinc/cp-schema-registry > images/cp-schema-registry.tar
	docker pull confluentinc/cp-kafka-connect
	docker save confluentinc/cp-kafka-connect > images/cp-kafka-connect.tar
	docker pull confluentinc/cp-enterprise-control-center
	docker save confluentinc/cp-enterprise-control-center > images/cp-enterprise-control-center.tar
	docker pull neo4j:4.4.8-community
	docker save neo4j:4.4.8-community > images/neo4j.4.4.8-community.tar
	docker pull node:16.15.0-alpine
	docker save node:16.15.0-alpine > images/node.16.15.0-alpine.tar

# docker load < images/node.16.15.0-alpine.tar
loadLocalizedImage: 
	mkdir -p images
	docker load < images/postgres.tar
	docker load < images/keycloak.19.0.1.tar
	docker load < images/cp-zookeeper.tar
	docker load < images/cp-kafka.tar
	docker load < images/cp-schema-registry.tar
	docker load < images/cp-kafka-connect.tar
	docker load < images/cp-enterprise-control-center.tar
	docker load < images/neo4j.4.4.8-community.tar

LoadLocalizedImageNpm: 
	docker load < images/my_api.tar
	docker load < images/my_client.tar