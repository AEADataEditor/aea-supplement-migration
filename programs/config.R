#Any libraries needed are called and if necessary installed through `libraries.R`:


if (file.exists(file.path(basepath,".Renviron"))) {
readRenviron(file.path(basepath,".Renviron"))
}

# Output files for authors and later deposits
finalbatch.csv <- file.path(acquired, "icpsr_dois_2025_may.csv")
finalbatch.rds <- file.path(acquired, "icpsr_dois_2025_may.rds")
creators.csv <- file.path(acquired, "icpsr_dois_2025_may_creators.csv")
creators.rds <- file.path(acquired, "icpsr_dois_2025_may_creators.rds")
related_identifiers.csv <- file.path(acquired, "icpsr_dois_2025_may_related_identifiers.csv")
related_identifiers.rds <- file.path(acquired, "icpsr_dois_2025_may_related_identifiers.rds")

# Kranz files with filenames
kranz.src <- "http://econ.mathematik.uni-ulm.de/ejd/files.zip"
kranz.src2<- "http://econ.mathematik.uni-ulm.de/ejd/articles.zip"
kranz.zip <- file.path(interwrk,"kranz_files.zip") 
kranz.zip2 <- file.path(interwrk,"kranz_articles.zip") 
kranz.sql <- file.path(interwrk,"files.sqlite")
kranz.sql2 <- file.path(interwrk,"articles.sqlite")


file.ext.map.file <- "aea_file_ext.csv"

# Public location of repository
git.base = "https://github.com"
git.repo = "AEADataEditor/aea-supplement-migration"
git.raw = "blob/master"
