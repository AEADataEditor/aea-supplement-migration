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
     - [TODO] relationship comes from the "IsSupplement" link in DataCite Metadata
     - [TODO] citation comes from Scholix/etc. and could be other articles, not just the original article
     - currently: citations come from ICPSR-curated bibliography or openICPSR manual entry; relationship (currently) comes from marking a publication as "primary" manually
  - on AEA, showing both link
     - relationship comes from "HasSupplement" (?), see https://aeadataeditor.github.io/aea-supplementary-demo/better.html for an example
     - cites would come only if the article actually cites the supplement, and is driven by the regular references (needs new AEA style guide)
     - TODO: update CrossRef registration with linked supplements
- metadata-driven link to any other article that uses or references the data
- AEA branding
- attach article keywords to the data
  - JEL taxonomy - can  be entered, but cannot yet be validated upon entry
  - JEL guide: https://www.aeaweb.org/jel/guide/jel.php
- Size
  - Technically a 2GB limit (configurable) is placed on individual file size
  - Currently no limit on "project" or "deposits"

### Administrative
- track usage
  - https://www.openicpsr.org/openicpsr/repository/
  - per-portal
  - per-object
  - downloads, page views, related publications
  - programmatic access coming, human-viewable coming first

## Challenges
- DOI prefix will change from AEA to ICPSR.
  - Sign-in for download? is this an issue? [LARS]
- Copyright
  - AEA holds the copyright to article, supplements, supplementary materials (including code) for historical materials
  - AEA will NOT hold the copyright on either data or code on future deposits in either the AEA Code and Data Repository or in third-party repositories
- Licenses
  - Historic ingest: Currently, the AER currently does NOT assign any automatic license to supplements
  - Relicensing under CC-BY 4.0? [LARS]
  - What license can the user choose on openICPSR, if any (currently: CC-BY 4.0 only)? [JARED]
  - Going forward, what are the licensing options? [JARED]
  - Going forward, restricted access: https://www.icpsr.umich.edu/icpsrweb/content/ICPSR/access/restricted/index.html

## Desirable Workflow improvements
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

# Implementation of the migration
- Scripts (Python?) to populate the custom ICPSR format:
  - specs provided by ICPSR [as XLSX](RDF Mapping.xlsx) and as [derived CSV](RDF Mapping-StudyProject.csv)
- Timeframe
  - opening up of AEA portal on Jan 1, 2019 [tentative]
  - migration of historic content by Feb 28, 2019 [tentative]
  - announcement in "Report by the Data Editor" and blog posts when it actually happens.
