# libraries
require(shiny)

shinyUI(fluidPage(
  tags$head(
    # tags$link(rel = "stylesheet", type = "text/css", href = "app.css")
    tags$link(rel = "stylesheet", type = "text/css", href = "../www/global.css")
  ),
  titlePanel("SVX Multiselect"),
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "input_type",
        "Input Types:",
        choices = c(
          "Fetching",
          "Joining",
          "Aggregation",
          "Subqueries",
          "Performance",
          "slider",
          "text"
        )
      ),
      uiOutput("whereclause"),
      uiOutput("limit"),
      uiOutput("perfmetric"), #Performance metrics
      checkboxInput("showquery", "Show Query"),
      conditionalPanel("input.showquery == true",
        p(strong("SPARQL Query")),
        verbatimTextOutput("SPARQLquery")
      )
    ),
    mainPanel(
      # output the dynamic UI componenet
      tabsetPanel(
        tabPanel("Dynamic UI",
          uiOutput("ui"),
          tags$p("Input type:"),
          verbatimTextOutput("input_type_text"),
          tags$p( strong( "About this query:" ) ),
          tags$p( textOutput("about_query") )
        ),
        tabPanel("Table",
          dataTableOutput("resultsTable")
        )
      )
    )
  )
))
