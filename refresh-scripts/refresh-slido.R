# C. Savonen

# Download that Slido data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "slido")

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
  google_entry = "slido_googlesheet",
  config_file = yaml_file_path, 
  data_name = "slido"
)

yaml <- yaml::read_yaml(yaml_file_path)

drive_id <- "https://drive.google.com/drive/u/0/folders/1XWXHHyj32Uw_UyaUJrqp6S--hHnM0-7l"
slido_data <- get_slido_files(drive_id)
slido_names <- names(slido_data)

if (yaml$data_dest == "google") {
  lapply(slido_names, function(slido_sheet) {
    googlesheets4::write_sheet(slido_data[[slido_sheet]],
                               ss = yaml$slido_googlesheet,
                               sheet = slido_sheet
    )
  })
}

if (yaml$data_dest == "github") {
  lapply(slido_names, function(slido_sheet) {
    readr::write_tsv(
      slido_data[[slido_sheet]],
      file.path(folder_path, paste0(slido_sheet, ".tsv"))
    )
  })
}
sessionInfo()
