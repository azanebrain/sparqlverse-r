library(shiny)
library(SPARQL)

endpoint <- "http://ws-akeen:8080/runQuery.html"

# Define server logic 
shinyServer(function(input, output) {
  
predicateQuery <- "SELECT DISTINCT ?predicate where {GRAPH <tickit> {?s ?predicate ?o}}"

#output$predicates <-reactive({renderTable(t(SPARQL(endpoint, predicateQuery)$results))})

output$predicates <-renderTable(t(SPARQL(endpoint, predicateQuery)$results))

queryTemplate <- 
    "SELECT ?state (COUNT(*) AS ?total)
FROM <tickit>
WHERE { ?venue <venuestate> ?state .}
GROUP BY ?state ORDER BY desc(?total) ?state LIMIT ?:limit" 
  
  #query <-reactive({paste(queryTemplate, input$limit)})
  query <-reactive({gsub("\\?:limit", input$limit, queryTemplate)})
  
  results <-reactive({SPARQL(endpoint, query())$results})
  
  output$mostPopularStatePlot <- renderPlot({
    pie(results()$total, labels = results()$state)
  })
  
  # Generate an HTML table view of the data
  output$mostPopularStateTable <- renderDataTable({
    results()
  })
  
  output$SPARQLquery <- renderText({
    query()
  })
  
})