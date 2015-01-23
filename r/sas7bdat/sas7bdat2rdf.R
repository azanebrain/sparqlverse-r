#Prototype for converting SAS data sets (sas7bdat) to RDF  
library(sas7bdat)
#Set to working directory
setwd("~/sparqlverse-r/r/sas7bdat")

trim <- function( x ) {gsub("(^[[:space:]]+|[[:space:]]+$)", "", x)}
toIRI <- function(name){ gsub(" ", "", paste('<',name,'>'), fixed = TRUE)}

# Function sas7bdat2rdf
# Convert sas7bdat to csv, modify the header, 
# TBD: and convert csv to RDF or directly insert to SPARQLverse
sas7bdat2rdf <- function(sas7bdatfile){
  x<-read.sas7bdat(sas7bdatfile, debug=TRUE)
  names(x)<-toIRI(names(x))
  attributes(x)$row.names<-toIRI(attributes(x)$row.names)
  View(x)
  x
}

csv <- sas7bdat2rdf("calcmilk.sas7bdat")

# Function formatRowTTL Format CSV row to TTL
# rowname: the subject IRI for the row
# names: The column predicates (IRI's)
# row: the row vector
# 
formatRowTTL <- function(rowname, names, row){
  print(paste(rowname, names, row, '.' ))
}

# Function formatTTL Format CSV to TTL
# row 
# TBD: 'attributes(row)$row.names' is not returning row names 
formatTTL <- function(row){
  formatRowTTL(attributes(row)$row.names, names(row), row)
}
# test conversion of one row
# testFormatTTL <- function(df){
#   #formatRowTTL(attributes(csv)$row.names[1], names(csv), csv[1,] )
#   apply(formatRowTTL(attributes(csv)$row.names, names(csv), csv )
# }

ttlrow <- formatRowTTL(attributes(csv)$row.names[1], names(csv), csv[1,] )

# Test conversion to TTL
ttl <- apply(csv, 1, function(row){formatRowTTL(row.names(row), names(row), row)})

View(sas7bdat2rdf("calcmilk.sas7bdat"))
