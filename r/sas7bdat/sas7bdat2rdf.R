library(sas7bdat)
setwd("~/r/sas7bdat")

trim <- function( x ) {gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)}
toIRI <- function(name){ gsub(" ", "", paste('<',name,'>'), fixed = TRUE)}

sas7bdat2rdf <- function(sas7bdatfile){
  x<-read.sas7bdat(sas7bdatfile, debug=TRUE)
  names(x)<-toIRI(names(x))
  attributes(x)$row.names<-toIRI(attributes(x)$row.names)
  View(x)
  x
}

csv <- sas7bdat2rdf("calcmilk.sas7bdat")

formatRowTTL <- function(rowname, names, row){
  print(paste(rowname, names, row, '.' ))
}

formatTTL <- function(row){
  formatRowTTL(attributes(row)$row.names, names(row), row)
}

# formatTTL <- function(df){
#   #formatRowTTL(attributes(csv)$row.names[1], names(csv), csv[1,] )
#   apply(formatRowTTL(attributes(csv)$row.names, names(csv), csv )
# }

ttlrow <- formatRowTTL(attributes(csv)$row.names[1], names(csv), csv[1,] )


ttl <- apply(csv, 1, function(row){formatRowTTL(row.names(row), names(row), row)})

View(sas7bdat2rdf("calcmilk.sas7bdat"))
