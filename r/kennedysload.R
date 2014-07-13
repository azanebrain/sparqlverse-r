endpoint <- "http://ws-akeen:8080/"

load<- "DROP SILENT GRAPH <kennedys>;; LOAD <file:/home/paraccel/data/kennedys2.ttl> INTO GRAPH <kennedys>;; SELECT (count(*) as ?count)  FROM <kennedys> WHERE { ?s ?p ?o }"

results <- SPARQL(endpoint, load)$results

results$count
