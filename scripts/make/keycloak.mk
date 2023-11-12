exportKeycloakRealm: 
	sudo docker exec -it keycloak rm -rf /tmp/export
	sudo docker exec -it keycloak mkdir /tmp/export
	sudo docker exec -e QUARKUS_HTTP_HOST_ENABLED=false -it keycloak /opt/keycloak/bin/kc.sh export --file /tmp/export/$(realm).json --realm $(realm) 
	sudo docker cp keycloak:/tmp/export/$(realm).json $(filepath)

exportKeycloakRealmMoveToImport: 
	sudo docker exec -it keycloak rm -rf /tmp/export
	sudo docker exec -it keycloak mkdir /tmp/export
	sudo docker exec -e QUARKUS_HTTP_HOST_ENABLED=false -it keycloak /opt/keycloak/bin/kc.sh export --file /tmp/export/$(realm).json --realm $(realm) 
	sudo docker cp keycloak:/tmp/export/$(realm).json keycloak/realms/import/$(filepath)

importKeycloakRealm:
	docker exec -e QUARKUS_HTTP_HOST_ENABLED=false -it keycloak opt/keycloak/bin/kc.sh import --file $(filepath) --override true 

keyCloakStart: 
	docker exec -e QUARKUS_HTTP_HOST_ENABLED=false -it keycloak opt/keycloak/bin/kc.sh start-dev
