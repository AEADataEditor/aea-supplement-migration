# Knit the Rmd file in the programs directory
#
# General config

source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)
source(file.path(programs,"global-libraries.R"), echo=FALSE)

# Find and knit the Rmd file
rmd_file <- file.path(programs, "aea201910-migration.Rmd")

if (file.exists(rmd_file)) {
  cat(sprintf("Knitting %s...\n", rmd_file))
  rmarkdown::render(rmd_file)
  cat("Done!\n")
} else {
  cat(sprintf("Error: File not found: %s\n", rmd_file))
}
