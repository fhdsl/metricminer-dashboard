# C. Savonen

# Download that Calendly Data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))
source(file.path(root_dir, "refresh-scripts", "folder-setup.R"))

folder_path <- file.path("metricminer_data", "calendly")

# Declare and read in config file
yaml_file_path <- file.path(root_dir, "_config_automation.yml")
yaml <- yaml::read_yaml(yaml_file_path)

# Authorize Google
auth_from_secret("google",
                 refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
                 access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
                 cache = TRUE
)
# Authorize Calendly
auth_from_secret("calendly", token = Sys.getenv("METRICMINER_CALENDLY"))

user <- get_calendly_user()

events <- list_calendly_events(user = user$resource$uri) %>% 
  dplyr::select_if(~is.vector(.)) %>% 
  dplyr::select(-event_guests, -event_memberships)
  

setup_folders(
  folder_path = folder_path,
  google_entry = "calendly_googlesheet",
  config_file = yaml_file_path, 
  data_name = "calendly"
)

yaml <- yaml::read_yaml(yaml_file_path)

if (yaml$data_dest == "google") {
  googlesheets4::write_sheet(events,
                             ss = yaml$calendly_googlesheet, 
                             sheet = "calendly"
  )
}

if (yaml$data_dest == "github") {
  readr::write_tsv(events,
                   file.path(folder_path, "calendly.tsv")
  )
}
sessionInfo()
