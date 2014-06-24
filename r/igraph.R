library(igraph)

endpoint <- "http://ws-akeen:8080/runQuery.html"
  
personQ <-"SELECT DISTINCT ?name2 ?friend WHERE{GRAPH <tickit> { <person2> <firstname> ?name2. <person2> <friend> ?person. ?person <firstname> ?friend}}"

person<-SPARQL(endpoint, personQ)$results

person.network<-graph.data.frame(person, directed=F)

plot(person.network)
