endpoint <- "http://dev-irpg-sverse:8080/runQuery.html"

load<- "DROP SILENT GRAPH <d1187>;; LOAD <file:/root/data/data-1187.nt.gz> INTO GRAPH <d1187>;; SELECT (count(*) as ?count)  FROM <d1187> WHERE { ?s ?p ?o }"

results <- SPARQL(endpoint, load)$results

results$count
