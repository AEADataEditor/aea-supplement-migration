library(readr)
library(tidyverse) # I'm lazy

baseurl <- "https://github.com/AEADataEditor/aea-supplement-migration/raw/master/data/acquired"
# alternatively, if running locally
# baseurl <- "data/acquired"
aea_article_data  <- read_csv(file.path(baseurl,"aea_article_data.csv.gz"))
aea_issue_data    <- read_csv(file.path(baseurl,"aea_issue_data.csv.gz"))
aea_icpsr_mapping <- read_csv(file.path(baseurl,"aea_icpsr_mapping.20191014.txt"),
                                        col_names = c("icpsr_doi","zipfile"))  %>% 
                                mutate(zipfile = str_remove(zipfile,
                                                            fixed("Original Zip: ")))
aea_deposits <- left_join(aea_article_data,aea_icpsr_mapping,
                          by=c("icpsr_package_name"="zipfile")) %>% 
  left_join(aea_issue_data,by=c("issue_id"))
# oldest package
aea_deposits %>% filter(year==min(aea_deposits$year)) %>% 
  select(doi,title,journal,volume,issue, year,icpsr_doi)
