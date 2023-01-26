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

build-demo:
	make localizeImage
	make loadLocalizedImage
	docker-compose up -d
	make localizeAfterNpm
	make importDemo
	echo "Demo installed..."