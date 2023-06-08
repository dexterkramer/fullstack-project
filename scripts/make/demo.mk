exportDemo:
	make exportKeycloakRealm realm="demo" filepath="demo/__dump/keycloak/demo.json"
	make exportKeycloakRealm realm="kafka" filepath="demo/__dump/keycloak/kafka.json"
	make exportNeo4jCypher database="demoapidatabase" filePath="demo/__dump/neo4j/demo.dump"

exportDemoMoveToImport:
	make exportKeycloakRealmMoveToImport realm="demo" filepath="demo.json"
	make exportKeycloakRealmMoveToImport realm="kafka" filepath="kafka.json"
	make exportNeo4jCypherMoveToImport database="demoapidatabase" filePath="demo.dump"

importDemo:
	importNeo4jCypher database="demoapidatabase" filePath="/import/demo.dump" 
	importKeycloakRealm filepath="/tmp/import/kafka.json"
	importKeycloakRealm filepath="/tmp/import/demo.json"

moveDumps:
	mkdir -p datas/neo4j-docker/neo4j-runtime/import/
	sudo cp demo/__dump/neo4j/demo.dump datas/neo4j-docker/neo4j-runtime/import/demo.dump
	sudo cp demo/__dump/keycloak/demo.json keycloak/realms/import/demo.json
	sudo cp demo/__dump/keycloak/kafka.json keycloak/realms/import/kafka.json

moveEnvs:
	sudo cp demo/__env/env.dist .env

getRepos:
	rm -rf ./apis/demo-api
	rm -rf ./clients/demo-frontend
	rm -rf ./datas/neo4j-docker
	git clone git@github.com:dexterkramer/demo-api.git ./apis/demo-api
	git clone git@github.com:dexterkramer/demo-frontend.git ./clients/demo-frontend
	git clone git@github.com:dexterkramer/neo4j-docker.git ./datas/neo4j-docker

build-demo:
	make getRepos
	make moveEnvs
	make moveDumps
	make localizeImage
	make loadLocalizedImage
	docker-compose up -d
	make localizeAfterNpm
	make importDemo
	echo "Demo installed..."