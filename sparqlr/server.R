library(shiny)
library(SPARQL)

endpoint <- "http://dev-irpg-sverse:8080/runQuery.html"
defaultLimit <- 10
endpoints <- c("http://localhost:3030/DS/query",   "http://dev-irpg-sverse:8080/runQuery.html", "http://ws-akeen:8080/runQuery.html")
predicateQuery <- "SELECT DISTINCT ?predicate where {GRAPH <tickit> {?s ?predicate ?o}}"

graphQuery <- "SELECT ?name WHERE {table \"stc_tbl_perm\"} ORDER BY ?id"

queryTemplate <- 
  "SELECT ?object (COUNT(*) AS ?total)
FROM <tickit>
WHERE { ?subject ?:predicate ?object .}
GROUP BY ?object ORDER BY desc(?total) ?object LIMIT ?:limit" 

# Define server logic 
shinyServer(function(input, output, session) {

bootstrap <- function(){
updateSelectInput(session, "endpoint", label = "Select Property To Query", choices = endpoints, selected = endpoint)
graphs <- paste(SPARQL(endpoint, graphQuery)$results)
updateSelectInput(session, "graph", label = "Select Graph To Query", choices = graphs, selected = "tickit")
predicates <- paste(SPARQL(endpoint, predicateQuery)$results)
updateSelectInput(session, "property", label = "Select Property To Query", choices = predicates, selected = "<venuestate>")
updateSliderInput(session, "limit", value = defaultLimit)
}
isolate (bootstrap())

#   observe({
#         x <- input$controller
#         updateSelectInput(session, "endpoint", label = "Select Property To Query", choices = endpoints, selected = endpoint)
#         graphs <- paste(SPARQL(endpoint, graphQuery)$results)
#         updateSelectInput(session, "graph", label = "Select Graph To Query", choices = graphs, selected = "tickit")
#         predicates <- paste(SPARQL(endpoint, predicateQuery)$results)
#         updateSelectInput(session, "property", label = "Select Property To Query", choices = predicates, selected = "<venuestate>")
#         updateSliderInput(session, "limit",label = paste("Limit query results:", x), value = defaultLimit)
#       })
    


  query <-reactive({temp <- gsub("\\?:limit", input$limit, queryTemplate)
                    gsub("\\?:predicate", input$property, temp)})
  
  
  results <-reactive({SPARQL(input$endpoint, query())$results})
  
  output$mostPopularStatePlot <- renderPlot({
    pie(results()$total, labels = results()$object)
  })
  
  # Generate an HTML table view of the data
  output$mostPopularStateTable <- renderDataTable({
    results()
  })
  
  output$property <- renderPrint ({
    input$property
  })
  
  output$SPARQLquery <- renderText({
    query()
  })
  
})