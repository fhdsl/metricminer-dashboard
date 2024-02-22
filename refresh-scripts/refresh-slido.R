# C. Savonen

# Download that Slido data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "slido")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Declare command line options
option_list <- list(
  optparse::make_option(
    c("--drive_id"),
    type = "character",
    default = NULL,
    help = "Google DriveID that you want to retrieve Slido results files from"
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

slido_data <- get_slido_files(opt$drive_id)

saveRDS(slido_data , file.path(output_dir, "slido_metrics.RDS"))

sessionInfo()
