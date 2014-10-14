# libraries
library(ggplot2)
library(igraph)
library(shiny)
library(SPARQL)

# vars
endpoint <- includeText("endpoint.txt")

# endpointExists <- getURL('http://svx.sparqlcity.com:8080')
# endpointExists <- domain('http://svx.sparqlcity.com:8080' )
# http://shiny.rstudio.com/reference/shiny/latest/ - extending shiny section
endpointExists <- FALSE
# endpointExists <- htmlDependency(name="svx", src="http://ws-azane:8080/svx.html")
# htmlDependency(name="svx", c(file="svx.html", href="http://ws-azane:8080"))

if ( endpointExists == TRUE ) {
# if ( typeof(endpointExists) == "character" ) {
  queryTemplateFetch <- "endpoint exists"
} else {
  queryTemplateFetch <- "endpoint does NOT exist"
  # queryTemplateFetch <- typeof(endpointExists)
}

# x <- SPARQL(endpoint, "select ?g where { graph?g{} }")
x <- 'list(g = "<tickit>") NULL'

# Now test that the correct table is loaded
# endpointExists <- SPARQL(endpoint, "select ?g where { graph?g{} }") 
endpointExists <- 'list(g = "<tickit>") NULL'

# if ( endpointExists == "ya" ) {
#   queryTemplateFetch <- "trueeee"
# } else if ( endpointExists == '' ) {
#   queryTemplateFetch <- "End point is off"
# # } else if ( grep( 'tickit', endpointExists ) ) {
#   # queryTemplateFetch <- paste ( "grep found tickit:" , endpointExists  )
# } else {
#   queryTemplateFetch <- "endpointExists"
# }

# grep will be 1 or '', so true or false?
# endpointExists <- 'list(g = "<tickit>") NULL' #works
endpointExists <- SPARQL(endpoint, "select ?g where { graph?g{} }") 

print ( paste('endpointExists: ' , endpointExists) )
print ( paste('grep one: ' , grep( 'tickit', endpointExists ) ) )
print ( paste('grep two: ' , grep( 'tickit', SPARQL(endpoint, "select ?g where { graph?g{} }") ) ) ) # When sbx is running and tickit is loaded, this returns 1

# If svx is not running, this will return NULL
  # Should be connection refused
if ( endpointExists == NULL || endpointExists == "list()" ) {
  print ("endpoint is null")
} else {

  print ("endpoint is NON null")
}
if ( grep( 'tickit', SPARQL(endpoint, "select ?g where { graph?g{} }") ) == 1 ) {
  queryTemplateFetch <- "SVX is running. Tickit is loaded."
} else {
  queryTemplateFetch <- "Failure."
}

# loaded: list(g = "<tickit>") NULL
# unloaded: list() NULL
# SVX unreachable: (empty)

# The query template
# queryTemplateFetch <- includeText("template-fetch.txt")
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
