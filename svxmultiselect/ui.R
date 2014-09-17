# libraries
library(shiny)

shinyUI(fluidPage(
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
          verbatimTextOutput("input_type_text")
        ),
        tabPanel("Table",
          dataTableOutput("resultsTable")
        )
      )
    )
  )
))