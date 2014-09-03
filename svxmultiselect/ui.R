# libraries
library(shiny)

shinyUI(fluidPage(
  titlePanel("SVX Multiselect"),
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "input_type",
        "Loading input types...",
        choices = c("slider","text")
      ),
      uiOutput("limit"),
      #checkboxInput(inputID = "showQuery",
      #  label = "Show Query",
      #  value = FALSE
      #),
      #conditionalPanel("input.showQuery == true",
      #  p(strong("SPARQL Query")),
      #  textOutput("SPARQLquery")
      #)
      textOutput("SPARQLquery")
    ),
    mainPanel(
      # output the dynamic UI componenet
      uiOutput("ui"),
      tags$p("Input type:"),
      verbatimTextOutput("input_type_text"),
      tags$p("Dynamic input value:"),
      verbatimTextOutput("dynamic_value")

    )
  )
))
