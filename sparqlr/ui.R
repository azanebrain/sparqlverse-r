library(shiny)

# Define UI for most popular states
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel(title = "The Most Popular", windowTitle = "The Most"),
  
  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
      selectInput("endpoint", "Choose a endpoint:", 
                  choices = c()
                  ),
      selectInput("graph", "Choose a graph:", 
                  choices = c()),
      selectInput("property", "Choose a property:", 
                  choices = c()),
      sliderInput("limit", 
                  "Limit query results:", 
                  min = 1,
                  max = 50, 
                  value = 1, 
                  animate=TRUE,
                  )),   
    checkboxInput(inputId = "showQuery",
                  label = "Show Query",
                  value = FALSE),    
    conditionalPanel("input.showQuery == true",
                     p(strong("SPARQL Query")),
                     textOutput("SPARQLquery")
    )),
  
  # Show the pie chart of most popular states
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("mostPopularStatePlot")),
      tabPanel("Table", dataTableOutput("mostPopularStateTable"))
    )
  )))