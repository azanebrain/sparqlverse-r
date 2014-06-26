endpoint <- "http://dev-irpg-sverse:8080/runQuery.html"

insert <- "DROP SILENT GRAPH <rinsert>;; INSERT DATA {GRAPH <rinsert>{<Fred><age>30. <Wilma><age>29. <Fred> <spouse> <Wilma>}};; SELECT *  FROM <rinsert> WHERE { ?s ?p ?o }"

results <- SPARQL(endpoint, insert)$results


