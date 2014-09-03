library(shiny)

# Define UI for most popular states
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("SVX Playground - Tickit Join"),

  # Slider to limit number of results returned
  # The sidebarPanel() function has been deprecated. fluiPage should be used in conjunction with sidebarLayout() instead.
  sidebarPanel(
    wellPanel(
      selectInput(
                  inputId = "whereclause",
                  "Loading WHERE clause examples...",
                  choices = c()
                  ),
      sliderInput("limit",
                  "Set Your Range:",
                  min = 1,
                  max = 500,
                  step = 1,
                  value = 10,
                  animate=TRUE
                  )
      ),
      checkboxInput(inputId = "showQuery",
                     label = "Show Query",
                     value = FALSE
                     ),
      conditionalPanel("input.showQuery == true",
                      p(strong("SPARQL Query")),
                      textOutput("SPARQLquery")
                     ),
   
      p(textOutput("options"))
    ),

  # Show the visualizations of the results
  mainPanel(
    tabsetPanel(
      tabPanel("EgoPlot", plotOutput("egoPlot")),
      tabPanel("Table", dataTableOutput("resultsTable"))
    )
  )))
