require(shiny)

# Define UI for forest fires
shinyUI(pageWithSidebar(

  # Application title
  headerPanel(title = "Forest Fires", windowTitle = "Forest Fires"),

  # Slider to limit number of results returned
  sidebarPanel(
    wellPanel(
      sliderInput("yearRange",
                  "Set Year Range:",
                  min = 1960,
                  max = 2008,
                  step = 1,
                  value = c(1960, 2008),
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
      tabPanel("Avg Acres/Fire Plot", plotOutput("avgAcresPerFirePlot")),
       tabPanel("Number Fires Plot", plotOutput("numberFiresPlot")),
       tabPanel("Acres Burned Plot", plotOutput("acresBurnedPlot")),
       tabPanel("Avg Acres/Fire Pie", plotOutput("avgFirePie"))
    )
  )))
