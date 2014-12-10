# libraries
require(ggplot2)
require(igraph)
require(shiny)
require(SPARQL)
require(shinyIncubator)

# vars
endpoint <- includeText("endpoint.txt")
dataset <- "tickit" # The dataset which should be loaded
recallCounter <- 1
loadmsg <- ""

# Make sure SVX is running at the endpoint
# If the data is not loaded this will return `list()` followed by NULL
# If the data is loaded this will return `list(g = \"<query return set>\")`
# If SVX is not running, this returns a typical "Opening ending line mismatch" fatal error
testDataset <- shinyServer(function(input,output,session){
  # Only run the load dataset query the first time this function runs
  if ( recallCounter == 1 ) {
    # print("Calling SPARQLverse to load the dataset")
    progressmax <- sample(35:50, 1)
    withProgress(session, min=1, max=progressmax, expr={
      for(i in 1:progressmax) {
        setProgress(message = 'Loading the dataset',
                    detail = 'The dataset has not been loaded. This may take a few moments...',
                    value=i)
        if(i == 30 ){
          SPARQL(endpoint, "DROP SILENT GRAPH <tickit> ;; LOAD <file:$(dflt_load_dir)/tickit.ttl> INTO GRAPH <tickit> ;; SELECT (count(*) as ?number_of_triples) FROM <tickit> WHERE { ?s ?p ?o }") #load the dataset
        }
        Sys.sleep(0.1)
      }
    })
    # print("sparql load query complete")
  }

  if( length( grep(dataset, SPARQL(endpoint, "select ?g where { graph?g{} }")) ) < 1 ) {
    recallCounter <<- recallCounter + 1
    if (recallCounter > 2){
      print(paste("The dataset is still not loaded (",recallCounter," recursions). Breaking the loop"))
      loadmsg <<- "There was an error loading the data. Please make sure the endpoint is setup correctly."
    } else {
      print(paste("The dataset is loading..."))
      # Wait for 5 seconds
      Sys.sleep(5)
      # Recurse this function
      testDataset()
    }
  } else {
    # Now refresh the page, generate the visualization, update the status message, etc
    print("The dataset has been successfuly loaded by Shiny. We should now generate the graph")
    loadmsg <<- "The dataset has been successfuly loaded. Please refresh the page."
  }
})

# Test that the correct table is loaded
loadedData <- SPARQL(endpoint, "select ?g where { graph?g{} }") # List of all the datasets that have been loaded

# Will return 1 if the target data set is loaded
# and nothing if it is not
if( length( grep(dataset, loadedData) ) < 1 ) {
  # The dataset is not loaded. Provide an error message
  shinyServer(function(input,output,session) {
    # print(paste("Dataset not loaded. Loading '",dataset,"'..."))
    # Begin testing if the correct dataset is loaded
    testDataset(input,output,session)
    # Update the error/status message
    output$data_error <- renderText({
      loadmsg
    })
  })
} else {
  print("The dataset is loaded.")
  # The query template
  queryTemplateFetch <- includeText("template-fetch.txt")
  queryTemplateJoin <- includeText("template-join.txt")
  queryTemplateAggregation <- includeText("template-aggregation.txt")

  shinyServer(function(input,output,session) {
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
      switch(input$input_type,
        "Fetching" = plotOutput("egoPlot"),
        "Joining" = plotOutput("egoPlot"),
        "Aggregation" = plotOutput("egoPlot")
      )
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
