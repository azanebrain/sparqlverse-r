library(shiny)

# Define UI for most popular states
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("SVX Playground - Tickit Fetch"),

  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
      selectInput(
        inputId = "playground",
        "Loading playground examples...",
        choices = c()
        ),
      # selectInput("whereclause", "Where clause",
      #             choices = c()
      #             ),
      sliderInput("limit",
                  "Set Your Range:",
                  min = 1,
                  max = 100,
                  step = 1,
                  value = c(10),
                  animate=TRUE
                  )
      ),
      checkboxInput(inputId = "showQuery",
                     label = "Show Query",
                     value = FALSE),
      conditionalPanel("input.showQuery == true",
                      p(strong("SPARQL Query")),
                      textOutput("SPARQLquery")
                     ),
    p( 
     textOutput("playgroundDisplay")
    )

    ),

  # Show the visualizations of the results
  mainPanel(
    tabsetPanel(
      tabPanel("EgoPlot", plotOutput("egoPlot")),
      tabPanel("Table", dataTableOutput("resultsTable"))
    )
  )))
