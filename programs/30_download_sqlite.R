# Download data

source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)
source(file.path(programs,"global-libraries.R"), echo=FALSE)


# download data for filenames

# Source:
# Sebastian Kranz. 2023. "Economic Articles with Data". https://ejd.econ.mathematik.uni-ulm.de/, accessed on (DATE)
# This should be output as a bib file, with today's date, if downloading again.

if ( !file.exists(kranz.zip) ) {
   download.file(url=kranz.src,destfile=kranz.zip)
   # this is where the bib file should be generated.
}

if ( file.exists(kranz.zip) ) {
	unzip(kranz.zip,exdir=dirname(kranz.sql))
}

if ( file.exists(kranz.sql) ) {
	    message("File from ",kranz.src," was successfully downloaded and extracted")
}

# now download the article database

if ( !file.exists(kranz.zip2) ) {
   download.file(url=kranz.src2,destfile=kranz.zip2)
   # this is where the bib file should be generated.
}

if ( file.exists(kranz.zip2) ) {
	unzip(kranz.zip2,exdir=dirname(kranz.sql2))
}

if ( file.exists(kranz.sql2) ) {
	    message("File from ",kranz.src2," was successfully downloaded and extracted")
}


