library(shiny)

# Define UI for most popular states
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("SVX Playground - Memory performance"),

  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
      sliderInput("limit",
                  "Set Your Range:",
                  min = 1,
                  max = 500,
                  step = 10,
                  value = c(10,500),
                  animate=TRUE
                  )
      ),
      checkboxInput(inputId = "showQuery",
                     label = "Show Query",
                     value = FALSE),
      conditionalPanel("input.showQuery == true",
                      p(strong("SPARQL Query")),
                      textOutput("SPARQLquery")
                     )),

  # Show the visualizations of the results
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("resultsPlot")),
      tabPanel("Table", dataTableOutput("resultsTable"))
    )
  )))
