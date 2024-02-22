# C. Savonen

# Download that Youtube data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "youtube")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Declare command line options
option_list <- list(
  optparse::make_option(
    c("--video_ids"),
    type = "character",
    default = NULL,
    help = "Youtube video that you want to retrieve metrics for"
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

youtube_metrics <- lapply(opt$video_ids, get_youtube_video_stats)

saveRDS(youtube_metrics, file.path(output_dir, "youtube_metrics.RDS"))

sessionInfo()
