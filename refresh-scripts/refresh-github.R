# C. Savonen

# Download that Github data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "github")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

# Read in config file
yaml <- yaml::read_yaml(file.path(root_dir, "_config_automation.yml"))

# Authorize
auth_from_secret("github", token = Sys.getenv("METRICMINER_GITHUB_PAT"))

gh_metrics <- get_multiple_repos_metrics(repo_names = yaml$gh_repos)

saveRDS(gh_metrics, file.path(output_dir, "gh_metrics.RDS"))

sessionInfo()
