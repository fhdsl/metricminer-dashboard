# C. Savonen

# Set up function for googlesheets data storage

library(metricminer)
library(magrittr)

setup_folders <- function(folder_path,
                          google_entry,
                          data_name,
                          config_file = file.path(root_dir, "_config_automation.yml")) {
  # Read in config file
  yaml <- yaml::read_yaml(config_file)

  # Save to github if we said that
  if (yaml$data_dest == "github") {
    output_dir <- file.path(root_dir, folder_path)
    dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  }

  if (yaml$data_dest == "google") {
    if (!(dirname(folder_path) %in% googledrive::drive_ls()$name)) {
      googledrive::drive_mkdir(dirname(folder_path))
    }
    if (!(basename(folder_path) %in% googledrive::drive_ls(dirname(folder_path))$name)) {
      googledrive::drive_mkdir(folder_path)
    }

    folder_id <- googledrive::drive_ls(file.path(dirname(folder_path))) %>%
      dplyr::filter(name == basename(folder_path)) %>%
      dplyr::pull(id)

    if (is.null(yaml[[google_entry]])) {
      # Make a new sheet since there isn't one
      sheet_id <- googlesheets4::gs4_create(data_name)

      googledrive::drive_mv(
        file = googledrive::as_id(sheet_id),
        path = googledrive::as_id(folder_id)
      )

      googledrive::drive_mv(
        file = googledrive::as_id(sheet_id),
        path = googledrive::as_id(folder_id)
      )

      # Store this sheet_id in the yaml
      yaml <- readLines(config_file)
      yaml <- stringr::str_replace(
        yaml,
        paste0("^", google_entry, ":$"),
        paste0(google_entry, ": ", googledrive::as_id(sheet_id))
      )

      writeLines(yaml, config_file)

      # Reread it back in
      yaml <- yaml::read_yaml(config_file)
    } else { 
      gsheet_test <- try(suppressMessages(googlesheets4::read_sheet(yaml[[google_entry]], range = "A1:F20", sheet = 1)), silent = TRUE)
      
      if (class(gsheet_test)[1] == "try-error") {
        stop(paste0("Can't find the provided gsheet check your the '", google_entry,"' in your _config_automation.yml file"))
      }
    }
  }

  return(paste0("Data will be stored in: https://docs.google.com/spreadsheets/d/", yaml[[google_entry]]))
}
