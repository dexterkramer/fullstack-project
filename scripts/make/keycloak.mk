exportKeycloakRealm: 
	sudo docker exec -it keycloak rm -rf /tmp/export
	sudo docker exec -it keycloak mkdir /tmp/export
	sudo docker exec -it keycloak /opt/keycloak/bin/kc.sh export --file /tmp/export/$(realm).json --realm $(realm) 
	sudo docker cp keycloak:/tmp/export/$(realm).json $(realm).json

exportKeycloakRealmMoveToImport: 
	sudo docker exec -it keycloak rm -rf /tmp/export
	sudo docker exec -it keycloak mkdir /tmp/export
	sudo docker exec -e QUARKUS_HTTP_HOST_ENABLED=false -it keycloak /opt/keycloak/bin/kc.sh export --file /tmp/export/$(realm).json --realm $(realm) 
	sudo docker cp keycloak:/tmp/export/$(realm).json $(realm).json
	sudo mv $(realm).json keycloak/realms/import/$(realm).json

importKeycloakRealm:
	sudo docker exec -e QUARKUS_HTTP_HOST_ENABLED=false -it keycloak opt/keycloak/bin/kc.sh import --file /tmp/import/$(realm).json