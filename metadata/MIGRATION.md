# Sample ICPSR-Metadata

- The [RDF Mapping.xlsx](RDF Mapping.xlsx) ([CSV version](RDF Mapping-StudyProject.csv)) describes the expected metadata fields.
- For the AEA migration, a sample RDF is in [sample/metadata.rdf](sample/metadata.rdf)

## Steps
From the list of supplements, do the following steps

- Obtain the list of files from the ZIP file
  - optionally: unpack it to get the mime-type and md5sum for each file
- From internal catalog, extract JEL keywords, encode as below
- Created a directory "citations"
- Generate a RIS file from the internal catalog, with custom field "`C1`" (see below)
- Generate the metadata.rdf
- Add the metadata.rdf and the citations directory to the (existing) ZIP file (working copy).
- Upload to ICPSR S3 bucket

## Enhancement

### JEL keywords
The standard ICPSR ingest has been modified/updated to allow for JEL keywords:
```
<rdf:Description rdf:about="file://root/project">
   <....>
   <dcterms:subject>file://root/project#subject</dcterms:subject>
 </rdf:Description>
```
and further in the RDF file
```
<rdf:Description rdf:about="file://root/project#subject">
    <rdf:_1>J61 Geographic Labor Mobility; Immigrant Workers</rdf:_1>
    <rdf:_2>O15 Economic Development: Human Resources; Human Development; Income Distribution; Migration</rdf:_2>
    <rdf:_3>P25 Socialist Systems and Transitional Economies: Urban, Rural, and Regional Economics</rdf:_3>
    <rdf:_4>P36 Socialist Institutions and Their Transitions: Consumer Economics; Health; Education and Training: Welfare, Income, Wealth, and Poverty</rdf:_4>
    <rdf:_5>Q54 Climate; Natural Disasters and Their Management; Global Warming</rdf:_5>
    <rdf:_6>R23 Urban, Rural, Regional, Real Estate, and Transportation Economics: Regional Migration; Regional Labor Markets; Population; Neighborhood Characteristics</rdf:_6>
    <rdf:type rdf:resource="http://www.w3.org/1999/02/22-rdf-syntax-ns#Seq"/>
</rdf:Description>
```

### Relationship
The ICPSR metadata does not yet handle relationship between primary publication and the supplement upon ingest. It currently only handles the (implicit) relationship "`cites`"/"`isCitedBy`".  This is handled through incorporation of a custom field in the RIS file that is used for the "`isCitedBy`" functionality:
```
 C1 : "isSupplementTo"
```
