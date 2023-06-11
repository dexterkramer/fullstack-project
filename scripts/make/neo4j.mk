exportNeo4jCypher: 
	sudo docker exec -it neo4j rm -rf /import/tmpCypherExport.dump
	sudo docker exec -it neo4j touch "/import/tmpCypherExport.dump"
	sudo docker exec -it neo4j chmod 777 "/import/tmpCypherExport.dump"
	sudo docker exec -it neo4j cypher-shell -u neo4j -p connect -d $(database) "CALL apoc.export.cypher.all('tmpCypherExport.dump');"
	sudo docker cp neo4j:/import/tmpCypherExport.dump $(filePath)
	sudo docker exec -it neo4j rm -rf /import/tmpCypherExport.dump

exportNeo4jCypherMoveToImport:
	sudo docker exec -it neo4j rm -rf /import/tmpCypherExport.dump
	sudo docker exec -it neo4j touch "/import/tmpCypherExport.dump"
	sudo docker exec -it neo4j chmod 777 "/import/tmpCypherExport.dump"
	sudo docker exec -it neo4j cypher-shell -u neo4j -p connect -d $(database) "CALL apoc.export.cypher.all('tmpCypherExport.dump');"
	sudo docker cp neo4j:/import/tmpCypherExport.dump datas/neo4j-docker/neo4j-runtime/import/$(filePath)

cleanNeo4jDatabase:
	sudo docker exec -it neo4j cypher-shell -u neo4j -p connect -d $(database) "match (a) -[r] -> () delete a, r"
	sudo docker exec -it neo4j cypher-shell -u neo4j -p connect -d $(database) "match (a) delete a"

importNeo4jCypher:
	docker exec -it neo4j cypher-shell -u neo4j -p connect -d $(database) "CALL apoc.cypher.runFile('$(filePath)')" 