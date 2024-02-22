# C. Savonen

# Download that Google Analytics data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "ga")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Declare command line options
option_list <- list(
  optparse::make_option(
    c("--ga_property_ids"),
    type = "character",
    default = NULL,
    help = "Property ids for websites you want google analytics from"
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

ga_metrics <- get_all_ga_metrics(property_ids = opt$ga_property_ids)

saveRDS(ga_metrics, file.path(output_dir, "ga_metrics.RDS"))

sessionInfo()
