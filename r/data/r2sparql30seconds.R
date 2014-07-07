library(SPARQL)
endpoint <- "http://dev-irpg-sverse:8080/"
query <- "SELECT (COUNT(*) AS ?nrTriples) FROM <kennedys> WHERE {?s ?p ?o}"
results <- SPARQL(endpoint, query)$results
results$nrTriples
