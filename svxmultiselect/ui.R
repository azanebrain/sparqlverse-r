# libraries
library(shiny)

shinyUI(fluidPage(
  titlePanel("SVX Multiselect"),
  sidebarLayout(
    sidebarPanel(
      selectInput( inputId = "input_type",
        "Loading input types...",
        choices = c(
          "slider",
          "text",
          "Joining"
        )
      ),
      uiOutput("limit"),
      checkboxInput("showquery", "Show Query"),
      conditionalPanel("input.showquery == true",
        p(strong("SPARQL Query")),
        textOutput("SPARQLquery")
      )
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
