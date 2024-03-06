# C. Savonen

# Download that Citation Data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "citations")

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
  google_entry = "citation_googlesheet",
  config_file = yaml_file_path,
  data_name = "citation"
)

yaml <- yaml::read_yaml(yaml_file_path)

### Get citation data

all_papers <- lapply(yaml$citation_papers, function(paper) {
  df <- get_citation_count(paper)
  return(df)
})

all_papers <- dplyr::bind_rows(all_papers)



if (yaml$data_dest == "google") {
  googlesheets4::write_sheet(all_papers,
                             ss = yaml$citation_googlesheet,
                             sheet = "citation"
  )
}

if (yaml$data_dest == "github") {
  readr::write_tsv(all_papers,
                   file.path(folder_path, "citation.tsv")
  )
}
sessionInfo()
