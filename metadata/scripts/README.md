- Original is here https://www.aeaweb.org/articles?id=10.1257/app.20140362(but also attached)
- In order to grab the mime-type, I actually unpacked the Zip file.
- I then also cleaned it up (removed OS X related __MAC_OSX and .DS_store files/directories)
- I created the directory "citations" [your example had upper-case directory, but lower case in the RDF]
- I manually downloaded the RIS file from the website above. Thus, the only KNOWN citation is in the article that it accompanies (see note below)
- I then packaged everything back up into a new zip
- I kept the (misspelled?) name "metadat.rdf".
- I kept the original zip structure - the name "data/" is as-is. It *could* be something else in other cases.
- I added keywords manually from the website, one keyword per JEL classification line. Hope the RDF is well-formed

Citations:
- your current schema only uses the "isCiteBy" relationship.
- it should also contain the "isSupplementTo" (a DC term), which indicates a stronger relationship
- I have added the original article as a "isCitedBy" relationship, but in most cases, that is not strictly true (since the articles don't cite their supplements, in general).

This can be discussed.

Let me know as soon as you can whether this is the right format, and I will endeavor to create a script to generate the RDF from the ZIP files and the metadata.

Tentative thoughts on this:
- we have a list with article DOI and data supplement URL
- for each DOI:
  - download supplement
  - query DataCite for DOI metadata (author, title, abstract) -> RDF
  - unpack supplement
  - clean up Mac OS related stuff (often present, useless...)
  - for each file:
      - generate md5sum
      - identify mime-type
      - file description = file name (very sparse)
  - (not sure how to get keywords/JEL ;  they are well parseable from the DOI landing page as <ul class='jel_codes'>)
  - finalize RDF
  - create new zip
  - delete old zip

That should be relatively straightforward to implement in python or shell.
