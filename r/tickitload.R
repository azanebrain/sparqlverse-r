endpoint <- "http://dev-irpg-sverse:8080/runQuery.html"

load<- "DROP SILENT GRAPH <tickit>;; LOAD <file:$(dflt_load_dir)/tickit.ttl> INTO GRAPH <tickit>;; SELECT (count(*) as ?count)  FROM <tickit> WHERE { ?s ?p ?o }"

results <- SPARQL(endpoint, load)$results

results$count
