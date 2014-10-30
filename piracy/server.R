# libraries
library(SPARQL)
library(ggmap)

# vars
endpoint <- includeText("endpoint.txt")
# endpoint <- "http://semanticweb.cs.vu.nl/lop/sparql/"
dataset <- "piracy" # The dataset which should be loaded

# Make sure SVX is running at the endpoint
# ...

# Test that the correct table is loaded
loadedData <- SPARQL(endpoint, "select ?g where { graph?g{} }") # List of all the datasets that have been loaded
# Will return 1 if the target data set is loaded and nothing if it is not
if( length( grep(dataset, loadedData) ) < 1 ) {
  # The dataset is not loaded. Provide an error message
  shinyServer(function(input,output) {
    output$data_error <- renderText({
      "Data load ERROR. Make sure the correct dataset is loaded."
    })
  })
} else {
  # State that there are no further options to send to the SPARQL server
  options <- NULL

  prefix <- c("lop","http://semanticweb.cs.vu.nl/poseidon/ns/instances/",
    "eez","http://semanticweb.cs.vu.nl/poseidon/ns/eez/")
  sparql_prefix <- "PREFIX sem: <http://semanticweb.cs.vu.nl/2009/11/sem/>
    PREFIX poseidon: <http://semanticweb.cs.vu.nl/poseidon/ns/instances/>
    PREFIX eez: <http://semanticweb.cs.vu.nl/poseidon/ns/eez/>
    PREFIX wgs84: <http://www.w3.org/2003/01/geo/wgs84_pos#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    "

  # The queries
  sampleQuery <- "SELECT * from <piracy> WHERE {?event sem:hasPlace ?place . ?place eez:inPiracyRegion ?region . } LIMIT 25"
  # All the events and their geographic region
  eventsAndRegionQuery <- includeText('query-eventsandregion.txt')
  # Type of events that happened per region
  typeOfEventPerRegionQuery <- includeText('query-typeofeventperregion.txt')
  typeOfEventPerRegionMapQuery <- includeText('query-typeofeventperregion-map.txt')

  shinyServer(function(input,output) {
    # The query that is being sent to SVX
    query <- reactive({
      if (is.null(input$input_type)) {
        return(NULL)
      }
      else if (input$input_type == "Pie Chart" ) {
        temp <- sub("\\?:limit", input$limit[1], eventsAndRegionQuery)
      }
      else if (input$input_type == "Two Way Table" ) {
        temp <- sub("\\?:limit", input$limit[1], typeOfEventPerRegionQuery)
      }
      else if (input$input_type == "Map" ) {
        temp <- sub("\\?:limit", input$limit[1], typeOfEventPerRegionMapQuery)
      }
    })

    # The limit component
    output$limit <- renderUI({
      if (is.null(input$input_type)) {
        return()
      }
      switch(input$input_type,
        "Pie Chart" = sliderInput("limit",
          "Set the range:",
          min = 10,
          max = 500,
          step = 10,
          value = 50
        ),
        "Two Way Table" = sliderInput("limit",
          "Set the range:",
          min = 130,
          max = 1000,
          step = 10,
          value = 300
        ),
        "Map" = sliderInput("limit",
          "Set the range:",
          min = 10,
          max = 6000,
          step = 10,
          value = 50
        )
      )
    })

    # Render the main visualization
    output$ui <- renderUI({
      # Go through the inputs that will change the graph
      if (is.null(input$input_type)) {
        # If the user hasn't selected anything yet, return nothing
        return()
      }
      else {
        switch(input$input_type,
          "Pie Chart" = plotOutput("piePlot"),
          "Two Way Table" = plotOutput("twoWayTablePlot"),
          "Map" = plotOutput("mapPlot")
        )
      }
    })

    # Pie Plot
    output$piePlot <- renderPlot({
      q <- paste(sparql_prefix, query() )
      res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
      count_per_region <- table(res$region)
      sorted_counts <- sort(count_per_region)
      pie(sorted_counts, col=rainbow(12))
    }, width="auto", height=400 )

    # Two Way Table
    output$twoWayTablePlot <- renderPlot({
      q <- paste(sparql_prefix, query() )
      res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
      event_region_table <- table(res$event_type,res$region)
      par(mar=c(4,10,1,1))
      barplot(event_region_table, col=rainbow(10), horiz=TRUE, las=1, cex.names=0.8)
      legend("topright", rownames(event_region_table),
             cex=0.8, bty="n", fill=rainbow(10))
    }, width="auto", height=400 )

    # Map
    output$mapPlot <- renderPlot({
      q <- paste(sparql_prefix, query() )
      res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
      qmap('Gulf of Aden', zoom=2, legend='bottomright') +
      geom_point(aes(x=long, y=lat, colour=event_type), data=res) +
      scale_color_manual(values = rainbow(10))
      qmap('Gulf of Aden', zoom=2) +
      geom_point(aes(x=long, y=lat, colour=event_type), data=res) +
      scale_color_manual(values = rainbow(10))
    }, width="auto", height=400 )

    # Short blurb about the query and why it is interesting
    output$about_query <- renderText({
      if (is.null(input$input_type)) {
        return()
      }
      switch(input$input_type,
        "Pie Chart" = "Amount of piracy events and the geographical region where these events took place.",
        "Two Way Table" = "Amount of piracy events per region by type.",
        "Map" = "Amount of piracy events per region by type."
      )
    })

    # Table
    results <-reactive({SPARQL(endpoint, query())$results})
    output$resultsTable <- renderDataTable({
      results()
    })

    # The query (in text format) being sent to SVX
    output$SPARQLquery <- renderText({
      query()
    })

  })
}
