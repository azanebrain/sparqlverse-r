library(shiny)

# Define UI for forest fires
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(title = "Ego Group", windowTitle = "Ego Group"),
  
  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
      sliderInput("limit", 
                  "Set limit:", 
                  min = 1,
                  max = 100, 
                  step = 1,
                  value = 10, 
      )
      ),   
    checkboxInput(inputId = "showQuery",
                  label = "Show Query",
                  value = FALSE),    
    conditionalPanel("input.showQuery == true",
                     p(strong("SPARQL Query")),
                     verbatimTextOutput("SPARQLquery")
    )),
  
  # Show the pie chart of most popular states
  mainPanel(
    tabsetPanel(
      tabPanel("Table", dataTableOutput("resultsTable")),
      tabPanel("Graph", plotOutput("egoPlot"))
    )
  )))