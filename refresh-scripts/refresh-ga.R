# C. Savonen

# Download that Google Analytics data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "ga")

# Declare and read in config file
yaml_file_path <- file.path(root_dir, "_config_automation.yml")
yaml <- yaml::read_yaml(yaml_file_path)

# Authorize Google
auth_from_secret("google",
  refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
  access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
  cache = TRUE
)

# Set it up 
setup_folders(
  folder_path = folder_path,
  google_entry = "ga_googlesheet",
  config_file = yaml_file_path, 
  data_name = "ga"
)

# Get the metrics
metrics <- get_ga_stats(yaml$ga_property_ids, stats_type = "metrics")
dimensions <- get_ga_stats(yaml$ga_property_ids, stats_type = "dimensions")
link_clicks <- get_ga_stats(yaml$ga_property_ids, stats_type = "link_clicks")


if (yaml$data_dest == "google") {
  googlesheets4::write_sheet(metrics, 
                            yaml$ga_googlesheet, 
                            sheet = "metrics")
  googlesheets4::write_sheet(dimensions, 
                            yaml$ga_googlesheet, 
                            sheet = "dimensions")
  googlesheets4::write_sheet(link_clicks, 
                            yaml$ga_googlesheet, 
                            sheet = "link_clicks")
}

if (yaml$data_dest == "github") {
  readr::write_tsv(metrics, file.path(folder_path, "ga_metrics.tsv"))
  readr::write_tsv(dimensions, file.path(folder_path, "ga_dimensions.tsv"))
  readr::write_tsv(link_clicks, file.path(folder_path, "ga_link_clicks.tsv"))
}
  
sessionInfo()
