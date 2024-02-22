# C. Savonen

# Download that CRAN data

library(metricminer)
library(magrittr)
library(cranlogs)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "cran")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Read in config file
yaml <- yaml::read_yaml(file.path(root_dir, "_config_automation.yml"))

cran_stats <- cranlogs::cran_downloads(
  packages = yaml$cran_packages,
  from = "2009-05-06",
  to = "last-day")

saveRDS(cran_stats, file.path(output_dir, "cran_metrics.RDS"))

sessionInfo()
