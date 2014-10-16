# Piracy Demo

Description: Analysis utilizing multiple datasets from the Linked Open Piracy data set.

- [Original tutorial from LinkedScience.org](http://linkedscience.org/tools/sparql-package-for-r/linked-open-piracy-tutorial/)
- Data source: http://semanticweb.cs.vu.nl/poseidon/ns/browse/list_graphs

# Load the datasets

## Test each dataset individually

Some of the datasets have special characters we can't read, and relative paths. Test each set and make sure they are pristine.
```
LOAD <file:PATH/TO/DATA/FILE>
;;
SELECT (count(*) as ?number_of_triples) 
WHERE { ?s ?p ?o }
```

Example query:

SELECT ?event ?place ?region WHERE { ?event ?place ?region } LIMIT 50
```
DROP SILENT GRAPH <default>
;;
LOAD <file:/home/scl/data/piracy/piracy_eez_2012-01-25T15.ttl>
;;
  ## PREFIX sem: <http://semanticweb.cs.vu.nl/2009/11/sem/> 
  PREFIX poseidon: <http://semanticweb.cs.vu.nl/poseidon/ns/instances/> 
  PREFIX eez: <http://semanticweb.cs.vu.nl/poseidon/ns/eez/> PREFIX wgs84: <http://www.w3.org/2003/01/geo/wgs84_pos#> 
  PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> 
SELECT * WHERE {?event sem:hasPlace ?place . ?place eez:inPiracyRegion ?region . }
LIMIT 50
```

Dataset paths:
```
file:/home/scl/data/piracy/piracy_imb_2012-01-25T15.ttl
file:/home/scl/data/piracy/piracy_imb_2012-01-25T12.ttl
file:/home/scl/data/piracy/piracy_imb_2011-10-05T18.ttl
file:/home/scl/data/piracy/piracy_eez_2012-01-25T15.ttl
file:/home/scl/data/piracy/piracy_eez_2012-01-25T13.ttl
file:/home/scl/data/piracy/piracy_eez_2011-10-05T18.ttl
file:/home/scl/data/piracy/geonames.ttl
file:/home/scl/data/piracy/piracy_nga_2011-10-05T18.ttl
file:/home/scl/data/piracy/types_and_mappings.ttl
file:/home/scl/data/piracy/wordnet.ttl
file:/home/scl/data/piracy/sem.ttl
file:/home/scl/data/piracy/piracy_nga_imb_mapping_2011-10-05T18.ttl
```

Libraries
```
file:/home/scl/data/piracy/22-rdf-syntax-ns.ttl
file:/home/scl/data/piracy/core
file:/home/scl/data/piracy/owl
  file:/home/scl/data/piracy/rdf-schema.ttl
    Error - unsupported functionality: IRI requires leading alpha '../../2002/07/owl#Ontology' Please report the error to SPARQL City Support.
file:/home/scl/data/piracy/weapons_2012-02-01
  file:/home/scl/data/piracy/wgs84_pos
    Error - unsupported functionality: IRI requires leading alpha '../../../2000/01/rdf-schema#comment' Please report the error to SPARQL City Support.
```

# Query each DB
PREFIX sem: <http://semanticweb.cs.vu.nl/2009/11/sem/> PREFIX poseidon: <http://semanticweb.cs.vu.nl/poseidon/ns/instances/> PREFIX eez: <http://semanticweb.cs.vu.nl/poseidon/ns/eez/> PREFIX wgs84: <http://www.w3.org/2003/01/geo/wgs84_pos#> PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> SELECT * WHERE {?event sem:hasPlace ?place . ?place eez:inPiracyRegion ?region . }