# aea-supplement-migration
Code and information to migrate AEA data supplements to ICPSR

## Defining the scope
- In-scope are all supplements previously hosted on the AEA website
- In-scope are all future data and code deposits that are not elsewhere deposited

## Defining characteristics of the receiving repository
The receiving repository should have several attributes/facilities.

### User-facing
- metadata-driven link to original article (using CrossRef/DataCite facility) [[1](https://support.crossref.org/hc/en-us/articles/214357426)]
  - on ICPSR, showing both link, relationship, and citation(s) of article
     relationship comes 
  - on AEA, showing both link 
- metadata-driven link to any other article that uses or references the data
- AEA branding
- attach article keywords to the data?

### Administrative
- ability to use the AEA DOI namespace
- ability to use the AEA DOI format
- track usage

## Challenges
- ICPSR uses DataCite for DOI, AEA uses CrossRef for DOI - use of semantics in DOI? 
  - AEA prefix on DataCite? 
  - Registering data on CrossRef?
  - ICPSR prefix with AEA-style suffix
  - ICPSR works through DARA with DataCite
- Sign-in for download?
- Licenses? Copyright?
- Link to Github/Gitlab/etc. for code deposit
- Link to Dropbox, Box, etc. for deposit
- Generically, API for programmatic, rather than manual, deposit (SWORD2?)
- What about user-initiated openICPSR deposits that are subsequently related to AEA? "Virtual" portal/ reassignment? Manual? Automatic, based on DOI or prov link of related article?


## Relationships
There are a few links that CrossRef allows the journal to incorporate (see https://support.crossref.org/hc/en-us/articles/214357426) 

- Dataset generated as part of research results 	"isSupplementedBy"
- Dataset produced by a different set of researchers or previously published 	"references"
- Preprint 	"hasPreprint"

CrossRef says

  When DOIs are used a bidirectional relation is automatically created when a relation is created in the deposit of one item in a pair. The DOI deposited with metadata creating the relation is said to be the claimant, the other item does not need to have its metadata directly contain the relationship.

# Implementation
- Scripts (Python?) to populate the BagIt format? Who?
- Timeframe?
- Setup of a "AEA Portal"
- Setup of a future deposit and sharing facility?
