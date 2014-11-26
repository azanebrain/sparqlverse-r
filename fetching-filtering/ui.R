# libraries
require(shiny)
require(shinyIncubator)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "../www/global.css")
  ),
  # progressInit() must be called somewhere in the UI in order for the progress UI to actually appear
  progressInit(),
  titlePanel("Fetching & Filtering"),
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "input_type",
        "Input Types:",
        choices = c(
          "Fetching",
          "Joining",
          "Aggregation"
        )
      ),
      # uiOutput("whereclause"),
      uiOutput("limit"),
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
          textOutput("data_error"),
          uiOutput("ui"),
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
