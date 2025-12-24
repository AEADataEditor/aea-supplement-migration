# Download ONET and BLS OES data
# Data is about 50MB - depending on your connection, this might take a while.
# Data unfortunately only go to 2024 - won't work for one part of this project.

source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)
source(file.path(programs,"global-libraries.R"), echo=FALSE)

# library(RSQLite)
# library(dplyr)
# library(skimr)
# library(stringr)
# library(tidylog)

# exclusions to not consider

exclusions.ext <- c("eps","pdf","doc","docx","ps","csv","dta","tex")

dep.files = c("environment.yml","requirements.txt",
              "project.toml","manifest.toml",
              "renv.lock")

files_db <- dbConnect(RSQLite::SQLite(), kranz.sql)
articles_db <- dbConnect(RSQLite::SQLite(), kranz.sql2)

# ingest the articles db
dbGetQuery(articles_db,"SELECT id,journ,title,year,date,vol,issue,artnum,
           article_url,has_data,data_url,article_doi,data_doi FROM article  ;") -> articles
names(articles)

# ingest files

dbGetQuery(files_db,"SELECT * from files;") -> files.df
names(files.df)
# [1] "id"        "file"      "file_type" "kb"        "nested"   
skim(files.df)

# Test
articles %>%  distinct(journ,.keep_all = TRUE)

# transform by journal specific pattern (in the absence of DOI)
articles %>%
  mutate(publisher = case_when(
    str_detect(article_url,fixed("aeaweb")) ~ "aea",
    str_detect(article_url,fixed("oup.com")) ~ "oup",
    str_detect(article_url,fixed("uchicago")) ~ "ucp",
    str_detect(article_url,fixed("econometric")) ~ "ecta",
    TRUE ~ "other"),
    article_doi = case_when(
      !is.na(article_doi) ~ article_doi,
      # https://www.aeaweb.org/articles?id=10.1257/aer.20150361  
      publisher == "aea" ~ str_remove(article_url,fixed("https://www.aeaweb.org/articles?id=")),
      # https://academic.oup.com/restud/article/81/1/1/1727641
      # publisher == "oup" ~ cannot be transformed
      # https://www.journals.uchicago.edu/doi/abs/10.1086/704494     
      publisher == "ucp" ~ str_remove(article_url,fixed("https://www.journals.uchicago.edu/doi/abs/"))
      # https://www.econometricsociety.org/publications/econometrica/2019/01/01/aggregate-betting-data-individual-risk-preferences
      # publisher == "ecta" ~ cannot be transformed
    )
  )

# We may need to match on vol/issue/artnum instead for other journals

# Save the files to interwrk as Rds files, as-is

saveRDS(files.df,file.path(interwrk,"files.rds"))
saveRDS(articles,file.path(interwrk,"articles.rds"))

# Output the number of articles, journals, and years in the database

articles %>%
  summarize(articles=n(),
            journals=n_distinct(journ),
            years=range(year)) %>%
  write.csv(file.path(outputs,"articles-stats.csv"))



dbDisconnect(articles_db)

