# C. Savonen

# Download that Youtube Data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "youtube")

# Declare and read in config file
yaml_file_path <- file.path(root_dir, "_config_automation.yml")
yaml <- yaml::read_yaml(yaml_file_path)

# Authorize Google
auth_from_secret("google",
                 refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
                 access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
                 cache = TRUE
)

youtube_metrics <- lapply(yaml$video_ids, get_youtube_video_stats) 
names(youtube_metrics) <- yaml$video_ids

youtube_metrics <- dplyr::bind_rows(youtube_metrics, .id = "video")

setup_folders(
  folder_path = folder_path,
  google_entry = "youtube_googlesheet",
  config_file = yaml_file_path, 
  data_name = "youtube"
)

yaml <- yaml::read_yaml(yaml_file_path)

if (yaml$data_dest == "google") {
  googlesheets4::write_sheet(youtube_metrics,
                             ss = yaml$youtube_googlesheet, 
                             sheet = "youtube"
  )
}

if (yaml$data_dest == "github") {
  readr::write_tsv(youtube_metrics,
                   file.path(folder_path, "youtube.tsv")
  )
}

sessionInfo()
