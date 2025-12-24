# This file will get the migrated files from 2025
#
# General config

source(file.path(rprojroot::find_root(rprojroot::has_file("pathconfig.R")),"pathconfig.R"),echo=FALSE)
source(file.path(programs,"config.R"), echo=FALSE)
source(file.path(programs,"global-libraries.R"), echo=FALSE)

# Query DataCite for 2025 ICPSR DOIs that were registered between 2025-05-01 and 2025-05-31
# with the words "Replication data for:" in the title

# Load rdatacite package
pkgTest("rdatacite")

# Query parameters
start_date <- "2025-05-01"
end_date <- "2025-05-31"
title_query <- "Replication data for"
doi_prefix <- "10.3886"  # ICPSR DOI prefix

cat("Querying DataCite API for ICPSR DOIs using rdatacite...\n")
cat(sprintf("Date range: %s to %s\n", start_date, end_date))
cat(sprintf("DOI prefix: %s\n", doi_prefix))
cat(sprintf("Title query: %s\n", title_query))

# Query DataCite using dc_dois
# The query parameter uses Lucene syntax
query_string <- paste0('prefix:', doi_prefix, ' AND titles.title:"', title_query, '*"')

cat(sprintf("\nQuery string: %s\n\n", query_string))

# Perform the query
results <- rdatacite::dc_dois(query = query_string, limit = 1000)

# Check if we got results
if (!is.null(results) && length(results) > 0 && !is.null(results$data)) {
  icpsr_dois_all <- results$data

  cat(sprintf("Found %d DOIs total\n", nrow(icpsr_dois_all)))

  # Unnest attributes to get all fields
  if ("attributes" %in% names(icpsr_dois_all)) {
    # Unnest the attributes column
    attributes_df <- icpsr_dois_all %>%
      unnest_wider(attributes) %>%
      # Unnest titles to extract the title field
      unnest_wider(titles, names_sep = "_") %>%
      # Rename titles_title to just title
      rename(en_title = titles_1) %>%
      # unnest that!
      unnest_wider(en_title) %>%
      # Remove other titles fields if they exist
      select(doi, title, everything())

    cat(sprintf("Extracted attributes for %d DOIs\n", nrow(attributes_df)))

    # Filter by registered date range and DOI patterns
    icpsr_dois_2025 <- attributes_df %>%
      filter(!is.na(registered)) %>%
      mutate(registered_date = as.Date(substr(registered, 1, 10))) %>%
      filter(registered_date >= as.Date(start_date) & registered_date <= as.Date(end_date)) %>%
      # Keep only canonical versioned DOIs (with V1, V2, etc.) - exclude unversioned
      filter(grepl("V[0-9]+$", id, ignore.case = TRUE)) %>%
      # Exclude hyper-specific DOIs with dashes in the suffix (e.g., -180515)
      filter(!grepl("V[0-9]+-[0-9]+$", id, ignore.case = TRUE))

    cat(sprintf("After filtering to registered dates %s to %s: %d DOIs\n",
                start_date, end_date, nrow(icpsr_dois_2025)))

    # Create a separate tibble for creators (authors/affiliations)
    if ("creators" %in% names(icpsr_dois_2025)) {
      creators_df <- icpsr_dois_2025 %>%
        select(doi, creators) %>%
        unnest_wider(creators, names_sep = "_") %>%
        unnest_longer(creators_1) %>%
        unnest_wider(creators_1)

      cat(sprintf("Extracted %d creator records\n", nrow(creators_df)))

      # Save creators as CSV and RDS

      write.csv(creators_df, creators.csv)
      saveRDS(creators_df, creators.rds)

      cat(sprintf("Creators saved to: %s\n", creators.csv))
      cat(sprintf("Creators saved to: %s\n", creators.rds))

      # Remove creators from main tibble since we have it separately
      icpsr_dois_2025 <- icpsr_dois_2025 %>%
      select(-creators)
    }

    # Create a separate tibble for related identifiers 
    if ("relatedIdentifiers" %in% names(icpsr_dois_2025)) {
      related_identifiers_df <- icpsr_dois_2025 %>%
        select(doi, relatedIdentifiers) %>%
        unnest_wider(relatedIdentifiers, names_sep = "_") %>%
        unnest_longer(relatedIdentifiers_1) %>%
        unnest_wider(relatedIdentifiers_1) %>%
        # keep only the "IsSupplementTo" relation type
        filter(relationType == "IsSupplementTo")

      cat(sprintf("Extracted %d related identifier records\n", nrow(related_identifiers_df)))

      # Save creators as CSV and RDS

      write.csv(related_identifiers_df, related_identifiers.csv)
      saveRDS(related_identifiers_df, related_identifiers.rds)

      cat(sprintf("Related identifiers saved to: %s\n", related_identifiers.csv))
      cat(sprintf("Related identifiers saved to: %s\n", related_identifiers.rds))

      # Remove related identifiers from main tibble since we have it separately
      icpsr_dois_2025 <- icpsr_dois_2025 %>%
      select(-relatedIdentifiers)
    }
    



    if (nrow(icpsr_dois_2025) > 0) {
      # Save the results as CSV and RDS
      icpsr_dois_2025_pub <- icpsr_dois_2025 %>%
        select(doi,title,publicationYear,version,created,registered,updated)
      write.csv(icpsr_dois_2025_pub, finalbatch.csv)
      saveRDS(icpsr_dois_2025_pub, finalbatch.rds)

      cat(sprintf("\nResults saved to: %s\n", finalbatch.csv))
      cat(sprintf("Results saved to: %s\n", finalbatch.rds))
    } else {
      cat("No DOIs found in the specified date range\n")
    }
  } else {
    cat("No 'attributes' field found in the response\n")
    cat("Available fields:\n")
    print(names(icpsr_dois_all))
  }
} else {
  cat("No results found\n")
}
