library(shiny)

# Define UI for most popular states
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("SVX Playground - Memory performance"),

  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
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
      tabPanel("Plot", plotOutput("mostPopularStateLine")),
      tabPanel("Table", dataTableOutput("resultsTable"))
    )
  )))
