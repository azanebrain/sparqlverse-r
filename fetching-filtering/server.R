# libraries
library(ggplot2)
library(igraph)
library(shiny)
library(SPARQL)

# vars
endpoint <- includeText("endpoint.txt")
dataset <- "tickit" # The dataset which should be loaded

# Make sure the endpoint is operational
# CURRENTLY DISABLED
# endpointExists <- getURL('http://svx.sparqlcity.com:8080')
# endpointExists <- domain('http://svx.sparqlcity.com:8080' )
# http://shiny.rstudio.com/reference/shiny/latest/ - extending shiny section
# endpointExists <- FALSE
# cannot find htmlDependency()
# endpointExists <- htmlDependency(name="svx", src="http://sc-azane.actian.com:8080/svx.html")
# htmlDependency(name="svx", c(file="svx.html", href="http://sc-azane.actian.com:8080"))
# loadall <- 'SELECT (count(*) as ?number_of_triples) FROM <tickit> WHERE { ?s ?p ?o }'
# query_loadall <- SPARQL(endpoint, loadall) # A list element with the return value of the query
# print( paste("System status: ", query_loadall ) )
# loaded: list(g = "<tickit>") NULL
# unloaded: list() NULL
# SVX unreachable: (empty)

# Make sure SVX is running at the endpoint
# If the data is not loaded this will return list() followed by NULL
# If the data is loaded this will return list(g = \"<query return set>\")
# If SVX is not running, this returns a typical "Opening ending line mismatch" fatal error

# Test that the correct table is loaded
loadedData <- SPARQL(endpoint, "select ?g where { graph?g{} }") # List of all the datasets that have been loaded

# Will return 1 if the target data set is loaded and nothing if it is not
if( length( grep(dataset, loadedData) ) < 1 ) {
  # The dataset is not loaded. Provide an error message
  shinyServer(function(input,output) {
    output$data_error <- renderText({
      "Data load ERROR. Make sure the correct dataset is loaded."
    })
    # input$goButton
  })
} else {
  # The query template
  queryTemplateFetch <- includeText("template-fetch.txt")
  queryTemplateJoin <- includeText("template-join.txt")
  queryTemplateAggregation <- includeText("template-aggregation.txt")

  shinyServer(function(input,output) {
    # The query that is being sent to SVX
    query <- reactive({
      if (is.null(input$input_type)) {
        return(NULL)
      }
      else if (input$input_type == "Fetching" ) {
          temp <- sub("\\?:limit", input$limit[1], queryTemplateFetch)
      }
      else if (input$input_type == "Joining" ) {
          temp <- sub("\\?:limit", input$limit[1], queryTemplateJoin)
      }
      else if (input$input_type == "Aggregation" ) {
          temp <- sub("\\?:limit", input$limit[1], queryTemplateAggregation)
      }
    })

    results <-reactive({SPARQL(endpoint, query())$results})
    # Ego Graph used for plots
    ego <-reactive({graph.data.frame(results())})

    # Render the main visualization
    output$ui <- renderUI({
      # Go through the inputs that will change the graph
      if (is.null(input$input_type)) {
        # If the user hasn't selected anything yet, return nothing
        return()
      }
      else {
        switch(input$input_type,
          "Fetching" = plotOutput("egoPlot"),
          "Joining" = plotOutput("egoPlot"),
          "Aggregation" = plotOutput("egoPlot")
        )
      }
    })

    # The limit component
    output$limit <- renderUI({
      if (is.null(input$input_type)) {
        return()
      }
      switch(input$input_type,
        "Fetching" = sliderInput("limit",
          "Set the range:",
          min = 1,
          max = 500,
          step = 1,
          value = 10
        ),
        "Joining" = sliderInput("limit",
          "Set the range:",
          min = 10,
          max = 500,
          step = 10,
          value = 50
        ),
        "Aggregation" = sliderInput("limit",
          "Set the range:",
          min = 1,
          max = 100,
          step = 1,
          value = 50
        )
      )
    })

    # Demo
    output$input_type_text <- renderText({
      input$input_type
    })

    # Ego Plot
    output$egoPlot <- renderPlot({
      plot(ego())
    }, width="auto", height=400 )

    # Short blurb about the query and why it is interesting
    output$about_query <- renderText({
      if (is.null(input$input_type)) {
        return()
      }
      switch(input$input_type,
        "Fetching" = "Fetches triples for a single person",
        "Joining" = "Determines where and when an event takes place",
        "Aggregation" = "A simple aggregation of events to determine the 10 most frequent events"
      )
    })

    # Table
    output$resultsTable <- renderDataTable({
      results()
    })

    # The query (in text format) being sent to SVX
    output$SPARQLquery <- renderText({
     query()
    })

  })

} # The data is loaded
