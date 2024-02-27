# C. Savonen

# Download that Google Forms data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "googleforms")

# Declare and read in config file
yaml_file_path <- file.path(root_dir, "_config_automation.yml")
yaml <- yaml::read_yaml(yaml_file_path)

# Authorize Google
auth_from_secret("google",
  refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
  access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
  cache = TRUE
)

# Collect the data!
google_forms <- get_multiple_forms(form_ids = yaml$google_forms)

setup_folders(
  folder_path = folder_path,
  google_entry = "gf_googlesheet",
  config_file = yaml_file_path, 
  data_name = "googleforms"
)

form_names <- names(google_forms)

yaml <- yaml::read_yaml(yaml_file_path)

if (yaml$data_dest == "google") {
  lapply(form_names, function(form_name) {
    googlesheets4::write_sheet(google_forms[[form_name]]$answers,
      ss = yaml$gf_googlesheet,
      sheet = form_name
    )
  })
}

if (yaml$data_dest == "github") {
  lapply(form_names, function(form_name) {
    readr::write_tsv(
      google_forms[[form_name]]$answers,
      file.path(folder_path, paste0(form_name, ".tsv"))
    )
  })
}

sessionInfo()
