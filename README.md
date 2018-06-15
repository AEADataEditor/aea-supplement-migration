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
     - relationship comes from the "IsSupplement" link in DataCite Metadata
     - citation comes from Scholix/etc. and could be other articles, not just the original article
     - currently: citations come from ICPSR-curated bibliography or openICPSR manual entry; relationship (currently) comes from marking a publication as "primary" manually
     - TODO: clarify what is feasible/when
  - on AEA, showing both link 
     - relationship comes from "HasSupplement" (?), see https://aeadataeditor.github.io/aea-supplementary-demo/better.html for an example
     - cites would come only if the article actually cites the supplement, and is driven by the regular references (needs new AEA style guide)
     - TODO: update CrossRef registration with linked supplements
- metadata-driven link to any other article that uses or references the data
- AEA branding
- attach article keywords to the data
  - JEL taxonomy - can it be entered and separately can it be validated? Does it need to be validated (ingest from Manuscript Central submission?)
  - JEL guide: https://www.aeaweb.org/jel/guide/jel.php
  - do JEL codes exist as XML or JSON? See linked XML here: https://www.aeaweb.org/econlit/jelCodes.php
  - TODO: can they be integrated as a separate metadata field? With or without validation? With specific searchability? [JARED]

## Cost of Portal
  - Branded portal costs: https://www.openicpsr.org/openicpsr/repository/
  - Historic ingest: [JARED] will figure out
  - Converting into BagIt or other: [LARS]
  
### Administrative
- track usage 
  - https://www.openicpsr.org/openicpsr/repository/
  - per-portal
  - per-object
  - downloads, page views, related publications
  - programmatic access coming, human-viewable coming first

## Challenges
- ICPSR uses DataCite for DOI, AEA uses CrossRef for DOI - use of semantics in DOI? 
  - AEA prefix on DataCite? 
  - Registering data on CrossRef?
  - ICPSR prefix with AEA-style suffix <- [JARED]
  - ICPSR works through DARA with DataCite
- Sign-in for download?
  - is this an issue? [LARS]
- Licenses? Copyright?
  - Historic ingest: What license does AER currently assign to supplements (implicitly or explicitly)? Relicensing under CC-BY 4.0?
 [LARS]
  - What license can the user choose on openICPSR, if any (currently: CC-BY 4.0 only)? [JARED]
  - Going forward, what are the licensing options? [JARED]
  - Going forward, restricted access: https://www.icpsr.umich.edu/icpsrweb/content/ICPSR/access/restricted/index.html

## Workflow improvements
- Link to Github/Gitlab/etc. for code deposit
- Link to Dropbox, Box, OSF, etc. for deposit
  - OSF is staging for active research, then archive it from there
- Generically, API for programmatic, rather than manual, deposit (SWORD2?) - still looking for funding...

- What about user-initiated openICPSR deposits that are subsequently related to AEA? "Virtual" portal/ reassignment? Manual? Automatic, based on DOI or prov link of related article?
  - fields and licenses?
  - download statistics OK
  - customized metadata OK
  - harvesting metadata (DataPass style) on the openICPSR AEA portal? [JARED]

## Historical Ingest
- BagIt format https://en.wikipedia.org/wiki/BagIt (confirmed? JARED)
- Needs metadata (provided by Lars, shell/template provided by Jared)
  - date of first publication
  - title (conversion from article)
  - other elements?

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
