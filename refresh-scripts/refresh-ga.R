# C. Savonen

# Download that Google Analytics data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "ga")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Read config file
yaml <- yaml::read_yaml(file.path(root_dir, "_config_automation.yml"))

# Authorize Google
auth_from_secret("google",
                 refresh_token = Sys.getenv("METRICMINER_GOOGLE_REFRESH"),
                 access_token = Sys.getenv("METRICMINER_GOOGLE_ACCESS"),
                 cache = TRUE
)

metrics <- get_ga_stats(yaml$ga_property_ids, stats_type = "metrics")
dimensions <- get_ga_stats(yaml$ga_property_ids, stats_type = "dimensions")
link_clicks <- get_ga_stats(yaml$ga_property_ids, stats_type = "link_clicks")

saveRDS(metrics, file.path(output_dir, "ga_metrics.RDS"))
saveRDS(dimensions, file.path(output_dir, "ga_dimensions.RDS"))
saveRDS(link_clicks, file.path(output_dir, "ga_link_clicks.RDS"))

sessionInfo()
