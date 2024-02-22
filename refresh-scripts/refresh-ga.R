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


metrics <- get_ga_stats(opt$ga_property_ids, stats_type = "metrics")
dimensions <- get_ga_stats(opt$ga_property_ids, stats_type = "dimensions")
link_clicks <- get_ga_stats(opt$ga_property_ids, stats_type = "link_clicks")

saveRDS(metrics, file.path(output_dir, "ga_metrics.RDS"))
saveRDS(dimensions, file.path(output_dir, "ga_dimensions.RDS"))
saveRDS(link_clicks, file.path(output_dir, "ga_link_clicks.RDS"))

sessionInfo()
