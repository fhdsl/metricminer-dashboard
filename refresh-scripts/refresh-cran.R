# C. Savonen

# Download that CRAN data

library(metricminer)
library(magrittr)
library(cranlogs)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "cran")

# Declare and read in config file
yaml_file_path <- file.path(root_dir, "_config_automation.yml")
yaml <- yaml::read_yaml(yaml_file_path)

# Authorize Google
auth_from_secret("google",
                 refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
                 access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
                 cache = TRUE
)

setup_folders(
  folder_path = folder_path,
  google_entry = "cran_googlesheet",
  config_file = yaml_file_path, 
  data_name = "cran"
)

yaml <- yaml::read_yaml(yaml_file_path)

cran_stats <- cranlogs::cran_downloads(
  packages = yaml$cran_packages,
  from = "2009-05-06",
  to = "last-day"
)

if (yaml$data_dest == "google") {
  googlesheets4::write_sheet(cran_stats,
                             ss = yaml$cran_googlesheet,
                             sheet = "cran"
  )
}

if (yaml$data_dest == "github") {
  readr::write_tsv(cran_stats,
                   file.path(folder_path, "github.tsv")
  )
}

sessionInfo()
