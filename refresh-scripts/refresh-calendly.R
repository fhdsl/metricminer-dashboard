# C. Savonen

# Download that Calendly Data

library(metricminer)
library(magrittr)

# Find .git root directory
root_dir <- rprojroot::find_root(rprojroot::has_dir(".git"))

output_dir <- file.path(root_dir, "data", "calendly")
dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)

auth_from_secret("calendly", token = Sys.getenv("METRICMINER_CALENDLY"))

user <- get_calendly_user()
events <- list_calendly_events(user = user$resource$uri)

saveRDS(events, file.path(output_dir, "calendly_metrics.RDS"))

sessionInfo()
