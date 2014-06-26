endpoint <- "http://dev-irpg-sverse:8080/runQuery.html"

load<- "DROP SILENT GRAPH <kennedys>;; LOAD <file:/root/kennedys2.ttl> INTO GRAPH <kennedys>;; SELECT (count(*) as ?count)  FROM <kennedys> WHERE { ?s ?p ?o }”

results <- SPARQL(endpoint, load)$results

results$count
