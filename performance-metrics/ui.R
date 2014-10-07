# libraries
library(shiny)

shinyUI(fluidPage(
  # tags$head(
    # tags$link(rel = "stylesheet", type = "text/css", href = "../www/global.css")
  # ),
  titlePanel("Performance Metrics"),
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "input_type",
        "Input Types:",
        choices = c(
          "CPU Usage",
          "Memory",
          "Communications"
        )
      ),
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