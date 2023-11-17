# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")
library(targets)
library(crew)
library(crew.cluster)
library(tarchetypes)
library(future)
library(future.callr)
plan(callr)
library(employer)
library(tidyverse)
library(glue)
library(DT)
library(qs)

# Set target options:
tar_option_set(
  storage = "worker",
  retrieval = "worker",
  packages = c("employer", "janitor", "conflicted", "here", "ggpubr",
               "tidyverse", "glue", "here", "targets", "DT", "qs"),
  imports = "employer",
  controller = crew_controller_local(workers = 1),
  memory = "transient",
  garbage_collection = TRUE,
  format = "qs"
)
# tar_make_clustermq() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
options(clustermq.scheduler = "multiprocess")

# tar_make_future() is an older (pre-{crew}) way to do distributed computing
# in {targets}, and its configuration for your machine is below.
# Install packages {{future}}, {{future.callr}}, and {{future.batchtools}} to allow use_targets() to configure tar_make_future() options.

# Run the R scripts in the R/ folder with your custom functions:
tar_source()
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  tar_target(
    calendars,
    calendar_df |>
      calendar_nested(
        nest_by = employee_no,
        event = tr_code
      ),
    pattern = map(calendar_df)
  ),
  tar_target(
    calendars,
    calendar_df |>
      calendar_nested(
        nest_by = employee_no,
        event = tr_code
      ),
    pattern = map(calendar_df)
  ),
  
  tar_render_rep(
    reports_calendars,
    "Rmd/calendar.Rmd",
    params = tibble(
      branch = 1:length(active_employees)
    )
  )
)
