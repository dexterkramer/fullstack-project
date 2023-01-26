# fullstack-project
A fullstack project with submodule and dev/production mode

# Goals : 

# Prerequisites :

Update your hosts to make keycloak oauth working localy with : 

127.0.0.1 keycloak








How to export keycloak realm "demo" : 

    1 - sudo docker exec -it keycloak bash

    2 - mkdir /tmp/export

    2 - /opt/keycloak/bin/kc.sh export --file /tmp/export/demo.json --realm demo

    3 - sudo docker cp keycloak:/tmp/export/demo.json demo.json

How to import keycloak realm "demo" : 

    1 - sudo docker exec -it keycloak bash

    2 - opt/keycloak/bin/kc.sh import --file /tmp/import/demo.json