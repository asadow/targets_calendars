# Created by use_targets().
# Follow the comments below to fill in this target script.
# Then follow the manual to check and run the pipeline:
#   https://books.ropensci.org/targets/walkthrough.html#inspect-the-pipeline # nolint

# Load packages required to define the pipeline:
library(conflicted)
conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")
library(targets)
library(tarchetypes)
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
  packages = c("employer", "tarchetypes", "janitor",
               "conflicted", "here", "ggpubr",
               "tidyverse", "glue", "here", "targets", "DT", "qs"),
  imports = "employer",
  controller = crew_controller_local(workers = 4),
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
# tar_source()
# source("other_functions.R") # Source other scripts as needed.

# Replace the target list below with your own:
list(
  tar_file(absent_file, "data/absent"),
  tar_target(absent, qs::qread(absent_file)),
  tar_group_by(
    absent_grouped,
    absent,
    employee_no,
  ),
  tar_target(
    active_employees,
    absent_grouped$employee_no |> unique()
  ),
  tar_target(
    calendars,
    absent_grouped |>
      calendar_nested(
        nest_by = employee_no,
        event = tr_code
      ),
    pattern = map(absent_grouped)
  ),
  tar_target(
    reports_calendars,
    command = rmarkdown::render(
      here::here("Rmd/calendar.Rmd"),
      output_file = paste0(calendars$employee_no[1], ".html")
    ),
    pattern = map(calendars)
  )
)
