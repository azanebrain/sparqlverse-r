endpoint <- "http://ws-akeen:8080/"

load<- "DROP SILENT GRAPH <d1187>;; LOAD <file:/home/paraccel/data/data-1187.nt.gz> INTO GRAPH <d1187>;; SELECT (count(*) as ?count)  FROM <d1187> WHERE { ?s ?p ?o }"

results <- SPARQL(endpoint, load)$results

results$count
