# libraries
library(ggplot2)
library(shiny)
library(SPARQL)

# vars
endpoint <- includeText("endpoint.txt")

# The query templates for each example
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
    else if (input$input_type == "CPU Usage" ) {
      queryTemplateCPUUsage
    }
    else if ( input$input_type == "Memory" ){
      queryTemplateMemory
    }
    else if ( input$input_type == "Communications" ) {
      queryTemplateCommunications
    }
  })

  results <-reactive({SPARQL(endpoint, query())$results})

  # Render the main visualization
  output$ui <- renderUI({
    # Go through the inputs that will change the graph
    if (is.null(input$input_type)) {
      # If the user hasn't selected anything yet, return nothing
      return()
    }
    else {
      switch(input$input_type,
        "CPU Usage" = plotOutput("cpuUsageLine"),
        "Memory" = plotOutput("memoryLine"),
        "Communications" = plotOutput("commLine")
      )
    }
  })

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
      "CPU Usage" = "The current system performance",
      "Memory" = "The current system performance",
      "Communications" = "The current system performance"
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
