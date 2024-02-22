# C. Savonen

# Download that CRAN data

library(metricminer)
library(magrittr)
library(cranlogs)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "cran")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Declare command line options
option_list <- list(
  optparse::make_option(
    c("--cran_packages"),
    type = "character",
    default = NULL,
    help = "CRAN Packages we want data from"
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

cran_stats <- cranlogs::cran_downloads(
  packages = opt$cran_packages,
  from = "2009-05-06",
  to = "last-day")

saveRDS(cran_stats, file.path(output_dir, "cran_metrics.RDS"))

sessionInfo()
