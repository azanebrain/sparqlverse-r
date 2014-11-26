# libraries
require(shiny)

shinyUI(fluidPage(
  navbarPage(
    "SVX",
    tabPanel("Component 1", uiOutput("ui") ),
    navbarMenu("Functionality",
      tabPanel("Joining", uiOutput("limit") )
    )
  ),
  titlePanel("SVX Multiselect"),
  mainPanel(
    # output the dynamic UI componenet
    uiOutput("ui"),
    tags$p("Input type:"),
    verbatimTextOutput("input_type_text"),
    tags$p("Dynamic input value:"),
    verbatimTextOutput("dynamic_value")
  )

))
