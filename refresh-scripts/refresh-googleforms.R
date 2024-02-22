# C. Savonen

# Download that Google Forms data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "googleforms")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Declare command line options
option_list <- list(
  optparse::make_option(
    c("--google_forms"),
    type = "character",
    default = NULL,
    help = "Google Forms that you want info from"
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

google_forms <- get_multiple_forms(form_ids = opt$google_forms)

saveRDS(google_forms, file.path(output_dir, "googleforms_metrics.RDS"))

sessionInfo()
