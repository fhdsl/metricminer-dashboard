# C. Savonen

# Download that Youtube data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "youtube")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Read in config file
yaml <- yaml::read_yaml(file.path(root_dir, "_config_automation.yml"))

# Authorize Google
auth_from_secret("google",
                 refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
                 access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
                 cache = TRUE
)

youtube_metrics <- lapply(yaml$video_ids, get_youtube_video_stats)

saveRDS(youtube_metrics, file.path(output_dir, "youtube_metrics.RDS"))

sessionInfo()
