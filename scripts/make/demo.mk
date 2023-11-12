exportDemo:
	make exportKeycloakRealm realm="demo" filepath="demo/__dump/keycloak/demo.json"
	make exportKeycloakRealm realm="kafka" filepath="demo/__dump/keycloak/kafka.json"
	make exportNeo4jCypher database="demoapidatabase" filePath="demo/__dump/neo4j/demo.dump"

exportDemoMoveToImport:
	make exportKeycloakRealmMoveToImport realm="demo" filepath="demo.json"
	make exportKeycloakRealmMoveToImport realm="kafka" filepath="kafka.json"
	make exportNeo4jCypherMoveToImport database="demoapidatabase" filePath="demo.dump"

importNeo4j:
	make importNeo4jCypher database="demoapidatabase" filePath="/import/demo.dump" 

importKeyCloak: 
	make importKeycloakRealm filepath="/opt/keycloak/data/import/kafka.json"
	make importKeycloakRealm filepath="/opt/keycloak/data/import/demo.json"

moveDumps:
	mkdir -p projects/demo/datas/neo4j-docker/neo4j-runtime/import/
	cp demo/__dump/neo4j/demo.dump projects/demo/datas/neo4j-docker/neo4j-runtime/import/demo.dump
	sudo cp demo/__dump/keycloak/demo.json projects/demo/keycloak/realms/import/demo.json
	sudo cp demo/__dump/keycloak/kafka.json projects/demo/keycloak/realms/import/kafka.json

moveEnvs:
	sudo cp demo/__env/env.dist projects/demo/.env

getRepos:
	git clone git@github.com:dexterkramer/demo-api.git ./projects/demo/apis/demo-api
	git clone git@github.com:dexterkramer/demo-frontend.git ./projects/demo/clients/demo-frontend
	git clone git@github.com:dexterkramer/neo4j-docker.git ./projects/demo/datas/neo4j-docker

saveRepos: 
	git clone git@github.com:dexterkramer/demo-api.git ./savedRepos/demo-api
	git clone git@github.com:dexterkramer/demo-frontend.git ./savedRepos/demo-frontend
	git clone git@github.com:dexterkramer/neo4j-docker.git ./savedRepos/datas/neo4j-docker

copySavedRepos: 
	cp -r ./savedRepos/demo-api ./projects/demo/apis/demo-api
	cp -r ./savedRepos/demo-frontend ./projects/demo/clients/demo-frontend
	cp -r ./savedRepos/datas/neo4j-docker ./projects/demo/datas/neo4j-docker

localizeAfterNpm:
	docker save my_api:latest > images/my_api.tar
	docker save my_client:latest > images/my_client.tar

localizeImage:
	mkdir -p images
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
	docker pull provectuslabs/kafka-ui
	docker save provectuslabs/kafka-ui > images/kafka-ui.tar

# docker load < images/node.16.15.0-alpine.tar
loadLocalizedImage: 
	docker load < images/postgres.tar
	docker load < images/keycloak.19.0.1.tar
	docker load < images/cp-zookeeper.tar
	docker load < images/cp-kafka.tar
	docker load < images/cp-schema-registry.tar
	docker load < images/cp-kafka-connect.tar
	docker load < images/cp-enterprise-control-center.tar
	docker load < images/neo4j.4.4.8-community.tar
	docker load < images/kafka-ui.tar

LoadLocalizedImageNpm: 
	docker load < images/my_api.tar
	docker load < images/my_client.tar

deployDemo:
	sudo rm -rf projects/demo/
	mkdir -p projects/demo/
	mkdir -p projects/demo/apis/
	mkdir -p projects/demo/clients/
	mkdir -p projects/demo/datas/
	cp -R keycloak/ projects/demo/keycloak/
	cp -R kafka/ projects/demo/kafka/
	cp docker-compose.yml projects/demo/docker-compose.yml
	cp docker-compose-kafka.yml projects/demo/docker-compose-kafka.yml
	cp docker-compose-kafka-ui.yml projects/demo/docker-compose-kafka-ui.yml
	make getRepos
	make moveEnvs
	make moveDumps
	make localizeImage
	make loadLocalizedImage
	docker compose -p fullstack -f projects/demo/docker-compose.yml up -d
	make localizeAfterNpm
	make importDemo
	docker compose -p fullstack -f projects/demo/docker-compose.yml -f projects/demo/docker-compose-kafka.yml up -d


redeployDemo:
	sudo rm -rf projects/demo/
	mkdir -p projects/demo/
	mkdir -p projects/demo/apis/
	mkdir -p projects/demo/clients/
	mkdir -p projects/demo/datas/
	cp -R keycloak/ projects/demo/keycloak/
	cp -R kafka/ projects/demo/kafka/
	cp docker-compose.yml projects/demo/docker-compose.yml
	cp docker-compose-kafka.yml projects/demo/docker-compose-kafka.yml
	cp docker-compose-keycloak.yml projects/demo/docker-compose-keycloak.yml
	cp docker-compose-neo4j.yml projects/demo/docker-compose-neo4j.yml
	cp docker-compose-kafka-ui.yml projects/demo/docker-compose-kafka-ui.yml
#	make getRepos
	make copySavedRepos
	make moveEnvs
	make moveDumps
	make loadLocalizedImage
#	make LoadLocalizedImageNpm
	docker compose -p fullstack -f projects/demo/docker-compose-keycloak.yml up -d
	sleep 20
	make importKeyCloak
	make stopDemo
	docker compose -p fullstack -f projects/demo/docker-compose-keycloak.yml -f projects/demo/docker-compose-neo4j.yml up -d
#	docker compose -p fullstack -f projects/demo/docker-compose-keycloak.yml -f projects/demo/docker-compose.yml up -d	
#	docker compose -p fullstack -f projects/demo/docker-compose-keycloak.yml -f projects/demo/docker-compose-neo4j.yml -f projects/demo/docker-compose-kafka.yml up -d
	docker compose -p fullstack -f projects/demo/docker-compose-keycloak.yml -f projects/demo/docker-compose-neo4j.yml -f projects/demo/docker-compose-kafka.yml -f projects/demo/docker-compose-kafka-ui.yml up -d
	make importNeo4j
	make logDemo

startDemo:
	docker compose -p fullstack -f projects/demo/docker-compose.yml up -d
	docker compose -p fullstack -f projects/demo/docker-compose.yml -f projects/demo/docker-compose-kafka.yml up -d
	make logDemo

devDemo:
	make loadLocalizedImage
	make LoadLocalizedImageNpm
	make startDemo

stopDemo:
	docker compose -p fullstack stop 

logDemo: 
	docker compose -p fullstack logs --tail=0 --follow

destroyDemo:
	docker compose -p fullstack stop 
	docker compose -p fullstack down -v --remove-orphans
	docker system prune -a --volumes -f