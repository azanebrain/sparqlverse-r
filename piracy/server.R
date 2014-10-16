# libraries
library(SPARQL)
library(ggmap)

# vars
endpoint <- includeText("endpoint.txt")
# endpoint <- "http://semanticweb.cs.vu.nl/lop/sparql/"

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

# The query template
# queryTemplateFetch <- "SELECT ?event ?place ?region from <piracy> WHERE { ?event ?place ?region } LIMIT 50"
queryTemplateFetch <- "SELECT * from <piracy> WHERE {?event sem:hasPlace ?place . ?place eez:inPiracyRegion ?region . }"
queryTemplateJoin <- queryTemplateFetch
queryTemplatePieSample <- queryTemplateFetch

shinyServer(function(input,output) {
  # The query that is being sent to SVX
  query <- reactive({
    if (is.null(input$input_type)) {
      return(NULL)
    }
    else if (input$input_type == "PieChart" ) {
        # temp <- sub("\\?:limit", input$limit[1], queryTemplateFetch)
        queryTemplateFetch
    } 
    else if (input$input_type == "EgoSample" ) {
        # temp <- sub("\\?:limit", input$limit[1], queryTemplateJoin)
        queryTemplateJoin
    } 
    else if (input$input_type == "PieSample" ) {
        # temp <- sub("\\?:limit", input$limit[1], queryTemplatePieSample)
        queryTemplatePieSample
    }
  })

  results <-reactive({SPARQL(endpoint, query())$results})
  # Ego Graph used for plots
  ego <-reactive({graph.data.frame(results())})

  # The limit component
  output$limit <- renderUI({
    if (is.null(input$input_type)) {
      return()
    }
    switch(input$input_type,
      "PieChart" = sliderInput("limit",
        "Set the range:",
        min = 1,
        max = 500,
        step = 1,
        value = 10
      ),
      "EgoSample" = sliderInput("limit",
        "Set the range:",
        min = 10,
        max = 500,
        step = 10,
        value = 50
      ),
      "PieSample" = sliderInput("limit",
        "Set the range:",
        min = 1,
        max = 100,
        step = 1,
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
        "PieChart" = plotOutput("piePlot"),
        "EgoSample" = plotOutput("egoPlot"),
        "PieSample" = plotOutput("pie"),
        "TwoWayTable" = plotOutput("twoWayTablePlot"),
        "Map" = plotOutput("mapPlot")
      )
    }
  })

  # Ego Plot
  output$egoPlot <- renderPlot({
    plot(ego())
  }, width="auto", height=400 )
  # Pie Plot
  output$pie <- renderPlot({
    #just a sample to make sure pie works
    slices <- c(10, 12,4, 16, 8)
    lbls <- c("US", "UK", "Australia", "Germany", "France")
    pie(slices, labels = lbls, main="Pie Chart of Countries")
  }, width="auto", height=400 )
  output$piePlot <- renderPlot({
    q <- paste(sparql_prefix, queryTemplateFetch)

    res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results

    count_per_region <- table(res$region)
    sorted_counts <- sort(count_per_region)

    pie(sorted_counts, col=rainbow(12))
  }, width="auto", height=400 )

  # Two Way Table
  output$twoWayTablePlot <- renderPlot({
    q <- paste(sparql_prefix,
      "SELECT *
       FROM <piracy>
       WHERE {
         ?event sem:eventType ?event_type .
         ?event sem:hasPlace ?place .
         ?place eez:inPiracyRegion ?region .
       } LIMIT 125")
    res <- SPARQL(endpoint,q,ns=prefix,extra=options)$results
    event_region_table <- table(res$event_type,res$region)
    par(mar=c(4,10,1,1))
    barplot(event_region_table, col=rainbow(10), horiz=TRUE, las=1, cex.names=0.8)
    legend("topright", rownames(event_region_table),
           cex=0.8, bty="n", fill=rainbow(10))
  }, width="auto", height=400 )

  # Map
  output$mapPlot <- renderPlot({
    q <- paste(sparql_prefix,
      "SELECT *
       FROM <piracy>
       WHERE {
         ?event sem:eventType ?event_type .
         ?event sem:hasPlace ?place .
         ?place wgs84:lat ?lat .
         ?place wgs84:long ?long .
       } LIMIT 125")
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
      "PieChart" = "A pie chart example with the actual piracy data",
      "EgoSample" = "An egoplot example with the actual piracy data to determine if it is working",
      "PieSample" = "A simple PieSample with hardcoded data"
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
