# C. Savonen

# Download that Google Forms data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "googleforms")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Read in config file
yaml <- yaml::read_yaml(file.path(root_dir, "_config_automation.yml"))

# Authorize Google
auth_from_secret("google",
                 refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
                 access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
                 cache = TRUE
)

google_forms <- get_multiple_forms(form_ids = yaml$google_forms)

saveRDS(google_forms, file.path(output_dir, "googleforms_metrics.RDS"))

sessionInfo()
