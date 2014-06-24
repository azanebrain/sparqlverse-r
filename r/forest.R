library(SPARQL) # SPARQL querying package
library(ggplot2)

endpoint <- "http://ws-akeen:8080/runQuery.html"

query <- 
  "PREFIX  dgp1187: <http://data-gov.tw.rpi.edu/vocab/p/1187/>
   SELECT ?ye ?fi ?ac ?avgperfire
   WHERE {GRAPH <d1187>{
    ?s dgp1187:year ?year .
    ?s dgp1187:fires ?fires .
    ?s dgp1187:acres ?acres .
		BIND(xsd:integer(?year) AS ?ye)
		BIND(xsd:double (?fires) as ?fi)
		BIND(xsd:double (?acres) as ?ac)
		BIND(?ac/?fi AS ?avgperfire)}}"

qd <- SPARQL(endpoint,query)
df <- qd$results

ggplot(df, aes(x=ye, y=avgperfire, group=1)) +
  geom_point() +
  stat_smooth() +
  scale_x_continuous(breaks=seq(1960, 2008, 5)) +
  xlab("Year") +
  ylab("Average acres burned per fire")

ggplot(df, aes(x=ye, y=fi, group=1)) +
  geom_point() +
  stat_smooth() +
  scale_x_continuous(breaks=seq(1960, 2008, 5)) +
  xlab("Year") +
  ylab("Number of fires")

ggplot(df, aes(x=ye, y=ac, group=1)) +
  geom_point() +
  stat_smooth() +
  scale_x_continuous(breaks=seq(1960, 2008, 5)) +
  xlab("Year") +
  ylab("Acres burned")

# In less than 5 mins we have written code to download just
# the data we need and have an interesting result to explore!

