# C. Savonen

# Download that Github data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "github")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Declare command line options
option_list <- list(
  optparse::make_option(
    c("--gh_repos"),
    type = "character",
    default = NULL,
    help = "GitHub repo names you want metrics from"
  )
)

# Read the arguments passed
opt_parser <- optparse::OptionParser(option_list = option_list)
opt <- optparse::parse_args(opt_parser)

gh_metrics <- get_multiple_repos_metrics(repo_names = opt$gh_repos)

saveRDS(gh_metrics, file.path(output_dir, "gh_metrics.RDS"))

sessionInfo()
