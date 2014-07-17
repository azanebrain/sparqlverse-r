library(ggplot2)
library(igraph)
library(shiny)
library(SPARQL)

endpoint <- "http://ws-akeen:8080/runQuery.html"

# Define server logic 
shinyServer(function(input, output) {
  
queryTemplate <- 
  "SELECT   DISTINCT ?personName ?friendName ?close
FROM <tickit>
WHERE{
  ?s <firstname> ?sfname.
  ?s <lastname> ?slname.
  ?o <firstname> ?ffname.
  ?o <lastname> ?flname.
  BIND(CONCAT(?sfname, ?slname) AS ?personName)
  BIND(CONCAT(?ffname, ?flname) AS ?friendName)
{
  { BIND (<person1> AS ?s)
    ?s <friend> ?o. 
   }
   UNION
   {
      <person1> <friend> ?s.
      <person1> <friend> ?o.
      ?s <friend> ?o 
   BIND(0 AS ?close)
    }
}} ORDER BY ?close ?s  LIMIT ?:limit"

    
query <-reactive({gsub("\\?:limit", input$limit, queryTemplate)})
results <-reactive({SPARQL(endpoint, query())$results})
ego <-reactive({graph.data.frame(results(), directed=F)})
#ego <- results()
#ego <- SPARQL(endpoint, "SELECT DISTINCT ?name2 ?friend WHERE{GRAPH <tickit> { <person2> <firstname> ?name2. <person2> <friend> ?person. ?person <firstname> ?friend}}")$results

  
output$egoPlot <- renderPlot({
  plot(ego())
}, width = "auto", height = 600)


# Generate an HTML table view of the data
output$resultsTable <- renderDataTable({
  results()
})

output$SPARQLquery <- renderText({
  query() 
})
  
})