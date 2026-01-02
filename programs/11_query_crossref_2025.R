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
pkgTest("purrr")

# Query parameters
start_date <- "2025-05-01"
end_date <- "2025-05-31"
title_query <- "Replication data for"
doi_prefix <- "10.3886"  # ICPSR DOI prefix

if (!file.exists(file.path(interwrk, "datacite_raw_2025.rds"))) {

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

  # Save the results in interwrk
  saveRDS(results, file.path(interwrk, "datacite_raw_2025.rds"))
  cat(sprintf("Raw DataCite results saved to: %s \n",
        file.path(interwrk, "datacite_raw_2025.rds")))
}


cat("Loading existing DataCite results from interwrk...\n")
results <- readRDS(file.path(interwrk, "datacite_raw_2025.rds"))




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
      # Convert list columns to character strings using map_chr
      mutate(
        title = map_chr(title, ~if(length(.x) > 0) .x[[1]] else NA_character_),
        lang = map_chr(lang, ~if(length(.x) > 0) .x[[1]] else NA_character_)
      ) %>%
      # Remove other titles fields if they exist
      select(doi, title, everything())

    cat(sprintf("Extracted attributes for %d DOIs\n", nrow(attributes_df)))

    # Filter by registered date range and DOI patterns
    icpsr_dois_2025_v1 <- attributes_df %>%
      filter(!is.na(registered)) %>%
      mutate(registered_date = as.Date(substr(registered, 1, 10))) %>%
      filter(registered_date >= as.Date(start_date) & registered_date <= as.Date(end_date)) %>%
      # Keep only canonical versioned DOIs (with V1, V2, etc.) - exclude unversioned
      filter(grepl("V[0-9]+$", id, ignore.case = TRUE)) %>%
      # Exclude hyper-specific DOIs with dashes in the suffix (e.g., -180515)
      filter(!grepl("V[0-9]+-[0-9]+$", id, ignore.case = TRUE)) %>%
      # remove updates of much earlier DOIs (starting with 'e1')
      filter(!grepl("/e1", id, ignore.case = TRUE))

    cat(sprintf("After filtering to registered dates %s to %s: %d DOIs\n",
                start_date, end_date, nrow(icpsr_dois_2025_v1)))

    # for each of the filtered DOIs, check the API to see if there is a V2 of the same DOI, and if yes, append that to the datasets.

    cat("\nChecking for V2 versions of filtered DOIs...\n")
    additional_v2_versions <- list()

    for (i in 1:nrow(icpsr_dois_2025_v1)) {
      current_doi <- icpsr_dois_2025_v1$doi[i]

      # Replace V1 with V2
      v2_doi <- gsub("V1$", "V2", current_doi, ignore.case = TRUE)

      # Only check if we actually replaced V1 (i.e., the DOI changed)
      if (v2_doi != current_doi) {
        cat(sprintf("Checking %d/%d: %s -> %s\n", i, nrow(icpsr_dois_2025_v1), current_doi, v2_doi))

        # Query DataCite for this specific DOI
        tryCatch({
          v2_result <- rdatacite::dc_dois(query = paste0('doi:', v2_doi), limit = 1)

          if (!is.null(v2_result$data) && nrow(v2_result$data) > 0) {
            cat(sprintf("  Found V2 version: %s\n", v2_doi))
            additional_v2_versions[[length(additional_v2_versions) + 1]] <- v2_result$data
          }
        }, error = function(e) {
          # Silently continue if DOI doesn't exist
        })
      }
    }

    # Process and append V2 versions if found
    if (length(additional_v2_versions) > 0) {
      cat(sprintf("\nFound %d V2 version(s)\n", length(additional_v2_versions)))

      # Combine all V2 versions into a single data frame
      additional_v2_df <- bind_rows(additional_v2_versions)
      # Save this file in interwrk
      saveRDS(additional_v2_df, file.path(interwrk, "datacite_raw_v2_2025.rds"))
      cat(sprintf("Additional V2 versions saved to: %s\n",
            file.path(interwrk, "datacite_raw_v2_2025.rds")))

      # Read back the file
      additional_v2_df <- readRDS(file.path(interwrk, "datacite_raw_v2_2025.rds"))
      
      # Process the V2 versions with the same unnesting logic
      icpsr_dois_2025_v2 <- additional_v2_df %>%
        unnest_wider(attributes) %>%
        unnest_wider(titles, names_sep = "_") %>%
        rename(en_title = titles_1) %>%
        unnest_wider(en_title) %>%
        mutate(
          title = map_chr(title, ~if(length(.x) > 0) .x[[1]] else NA_character_),
          lang = map_chr(lang, ~if(length(.x) > 0) .x[[1]] else NA_character_)
        ) %>%
        select(doi, title, everything())

      # Append to the main dataset
      icpsr_dois_2025 <- bind_rows(icpsr_dois_2025_v1, icpsr_dois_2025_v2)

      cat(sprintf("After adding V2 versions: %d DOIs total\n", nrow(icpsr_dois_2025)))
    } else {
      cat("\nNo V2 versions found\n")
      icpsr_dois_2025 <- icpsr_dois_2025_v1
    }


    # Create a separate tibble for related identifiers 
    if ("relatedIdentifiers" %in% names(icpsr_dois_2025)) {
      related_identifiers_df <- icpsr_dois_2025 %>%
        select(doi, relatedIdentifiers) %>%
        unnest_wider(relatedIdentifiers, names_sep = "_") %>%
        unnest_longer(relatedIdentifiers_1) %>%
        unnest_wider(relatedIdentifiers_1) 
      
      # Tabulate all relationTypes
      table(related_identifiers_df$relationType)

      related_identifiers_df <- related_identifiers_df %>%
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
