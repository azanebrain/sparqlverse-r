# libraries
require(ggplot2)
require(igraph)
require(shiny)
require(SPARQL)

# vars
endpoint <- includeText("endpoint.txt")

# The query templates for each example

# DEMO:
queryTemplateSlider <- "SELECT ?eventname LIMIT ?:limit"
queryTemplateText <- "SELECT ?p ?o
  FROM <tickit>
  WHERE { ?:whereclause }
  ORDER BY desc(?p) ?o
  LIMIT ?:limit
  "

# Functionality
queryTemplateFetch <- includeText("template-fetch.txt")
queryTemplateJoin <- includeText("template-join.txt")
queryTemplateAggregation <- includeText("template-aggregation.txt")
queryTemplateSubqueries <- includeText("template-subqueries.txt")

# Marketing

# Social Graph

# Fraud

# Finance

# Performance
queryTemplateCPUUsage<- includeText("template-cpuusage.txt")
queryTemplateMemory<- includeText("template-memory.txt")
queryTemplateCommunications<- includeText("template-communications.txt")


shinyServer(function(input,output) {
  # Does this function need 'session' like in svxtickitjoin ?

  # Modify the query statement depending on each unique interface
  # Each interface has different configurable values that must be modified in
  # the query that is being sent to SVX
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
    else if (input$input_type == "Subqueries" ) {
        temp <- sub("\\?:whereclause", input$whereclause, queryTemplateSubqueries)
    }
    else if (input$input_type == "Performance" ) {
        # If the user has selected the Performance graphs, figure out which metric the user wants to focus on
        if ( is.null(input$perfmetric) ) {
          queryTemplateCPUUsage
        }
        else if ( input$perfmetric == "Memory" ){
          queryTemplateMemory
        }
        else if ( input$perfmetric == "Communications" ) {
          queryTemplateCommunications
        } else {
          queryTemplateCPUUsage
        }
    }
    # Demo
    else if (input$input_type == "slider" ) {
        sub("\\?:limit", input$sliderlimit[1], queryTemplateSlider)
    }
    else if (input$input_type == "text" ) {
        temp <- sub("\\?:where", input$whereclause, queryTemplateText)
        sub("\\?:where", input$limit[1], temp)
    }
  })

  results <-reactive({SPARQL(endpoint, query())$results})
  # Ego Graph used for plots
  # ego <-reactive({plot.igraph(results())})
  ego <-reactive({graph.data.frame(results())})
  # ego <-reactive({graph.data.frame(results(), directed=F)})

  # Performance Metrics
  perfmetric <- reactive({
    #"user"
   if (is.null(input$input_type)) {
     return(NULL)
   }
   else {
     input$metric
   }
  })

  # Render the main visualization
  output$ui <- renderUI({
    # Go through the inputs that will change the graph
    if (is.null(input$input_type)) {
      # If the user hasn't selected anything yet, return nothing
      return()
    }
    # If the user has selected a Performance Metric
    else if ( input$input_type == "Performance" && ! is.null(input$perfmetric) ) {
      switch(input$perfmetric,
        "CPU Usage" = plotOutput("cpuUsageLine"),
        "Memory" = plotOutput("memoryLine"),
        "Communications" = plotOutput("commLine")
      )
    }
    else {
      switch(input$input_type,
        "Fetching" = plotOutput("egoPlot"),
        "Joining" = plotOutput("egoPlot"),
        "Aggregation" = plotOutput("egoPlot"),
        "Performance" = plotOutput("cpuUsageLine"),
        # Demo
        "slider" = sliderInput("dynamic", "Dynamic",
          min = 1, max = 20, value = 10),
        "text" = textInput("dynamic", "Dynamic",
          value = "starting value")
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
        value = 10,
        animate = TRUE
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
      ),
      "slider" = sliderInput("limit",
        "Set the range:",
        min = 1,
        max = 500,
        step = 1,
        value = 10,
        animate = TRUE
      )
    )
  })

  # The where clause component
  output$whereclause <- renderUI({
    if (is.null(input$input_type)) {
      return()
    }
    switch(input$input_type,
      "Subqueries" = textInput("whereclause", "Enter the WHERE clause:", "?s ?p ?o "),
      "text" = textInput("whereclause", "Enter the WHERE clause:", "<person2> ?p ?o")
    )
  })

  # Metric
  output$perfmetric <- renderUI({
    if (is.null(input$input_type)) {
      return()
    }
    switch(input$input_type,
      "Performance" = selectInput("perfmetric",
      "Select the metric:",
      choices = c(
        "CPU Usage",
        "Memory",
        "Communications"
        )
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

  # Line charts for system performance
  output$cpuUsageLine <- renderPlot({
    ggplot( data=results() , aes(x=requestnum) ) +
      # Create each line. Unfortunately the labels are titled 'colour'
      geom_line( aes(y=user , colour = 'user')) +
      geom_line( aes(y=sys, colour='sys')) +
      geom_line( aes(y=idle , colour = 'idle')) +
      geom_line(aes(y=iowait, colour='iowait'))  +
      scale_colour_manual(values=c("red","orange","blue","green")) + # The colors match the SVX GUI
      labs(colour="Metrics:") +
      xlab("Request Number") +
      ylab("")
  }, width = "auto", height = 400 )
  output$memoryLine <- renderPlot({
    ggplot( data=results() , aes(x=requestnum) ) +
      # Create each line. Unfortunately the labels are titled 'colour'
      geom_line( aes(y=size , colour = 'size')) +
      geom_line( aes(y=max , colour = 'max')) +
      scale_colour_manual(values=c("red", "blue")) + # The colors match the SVX GUI
      labs(colour="Metrics:") +
      xlab("Request Number") +
      ylab("")
  }, width = "auto", height = 400 )
  output$commLine <- renderPlot({
    ggplot( data=results() , aes(x=requestnum) ) +
      # Create each line. Unfortunately the labels are titled 'colour'
      geom_line( aes(y=bytes , colour = 'bytes')) +
      scale_colour_manual(values=c("blue")) + # The colors match the SVX GUI
      labs(colour="Metrics:") +
      xlab("Request Number") +
      ylab("")
  }, width = "auto", height = 400 )

  # Short blurb about the query and why it is interesting
  output$about_query <- renderText({
    if (is.null(input$input_type)) {
      return()
    }
    switch(input$input_type,
      "Fetching" = "Fetches triples for a single person",
      "Joining" = "Determines where and when an event takes place",
      "Aggregation" = "A simple aggregation of events to determine the 10 most frequent events",
      "Subqueries" = "Determines how many distinct subjects are in the Tickit dataset",
      "Performance" = "The current system performance",
      "slider" = "Adds a slider to the main panel",
      "text" = "Adds a text input box to the main panel"
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
