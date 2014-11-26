require(ggplot2)
require(shiny)
require(SPARQL)

# vars
endpoint <- includeText("endpoint.txt")
# Define server logic
shinyServer(function(input, output) {

queryTemplate <-
"PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX d1187: <http://data-gov.tw.rpi.edu/vocab/p/1187/>
SELECT ?ye ?fi ?ac ?avgperfire (?ac/?fi AS ?avgperfire)
WHERE {GRAPH <d1187>{
    ?s d1187:year ?year .
    ?s d1187:fires ?fires .
    ?s d1187:acres ?acres .
    BIND(xsd:integer(?year) AS ?ye)
    BIND(xsd:double(?fires) as ?fi)
    BIND(xsd:double(?acres) as ?ac)
FILTER(?ye >= ?:yearMin && ?ye <= ?:yearMax)
}}ORDER BY ?ye"

query <-reactive({temp <- gsub("\\?:yearMin", input$yearRange[1], queryTemplate)
                  gsub("\\?:yearMax", input$yearRange[2], temp)
})

results <-reactive({SPARQL(endpoint, query())$results})

output$avgAcresPerFirePlot <- renderPlot({
  p <- ggplot(results(), aes(x=ye, y=avgperfire, group=1)) +
    geom_point() +
    stat_smooth() +
    scale_x_continuous(breaks=seq(1960, 2008, 5)) +
    xlab("Year") +
    ylab("Average acres burned per fire")
  print(p)
}, width = "auto", height = 600)

output$numberFiresPlot <- renderPlot({
  p <- ggplot(results(), aes(x=ye, y=fi, group=1)) +
    geom_point() +
    stat_smooth() +
    scale_x_continuous(breaks=seq(1960, 2008, 5)) +
    xlab("Year") +
    ylab("Number of fires")
  print(p)
}, width = "auto", height = 600)

output$acresBurnedPlot <- renderPlot({
  p <- ggplot(results(), aes(x=ye, y=ac, group=1)) +
    geom_point() +
    stat_smooth() +
    scale_x_continuous(breaks=seq(1960, 2008, 5)) +
    xlab("Year") +
    ylab("Acres burned")
  print(p)
}, width = "auto", height = 600)

output$avgFirePie <- renderPlot({
  pie(results()$avgperfire, labels = results()$ye)
}, width = "auto", height = 800)

# Generate an HTML table view of the data
output$resultsTable <- renderDataTable({
  results()
})

output$SPARQLquery <- renderText({
  query()
})

})
