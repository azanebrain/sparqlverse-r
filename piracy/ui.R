# libraries
require(shiny)

shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "../www/global.css")
  ),
  titlePanel("Linked Open Piracy"),
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "input_type",
        "Graph Types:",
        choices = c(
          "Pie Chart",
          "Two Way Table",
          "Map"
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
