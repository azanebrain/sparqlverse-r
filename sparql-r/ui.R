library(shiny)

# Define UI for most popular states
shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("Most Popular States"),
  
  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
      selectInput("endpoint", "Choose a endpoint:", 
                  choices = c("http://ws-azane:8080", "http://ws-akeen:8080")),
      selectInput("property", "Choose a property:", 
                  choices = c("state", "event")),
      #                   choices = tableOutput("predicates")),
      sliderInput("limit", 
                  "Limit rows returned:", 
                  min = 1,
                  max = 50, 
                  value = 10, animate=TRUE)),    
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