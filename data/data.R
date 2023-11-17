
library(tidyverse)
library(employer)

.data <- nycflights13::flights
.data <- .data |> 
  mutate(
    date = as_date(time_hour)
  )


calendars <- .data |> 
  calendar_nested(
    nest_by = tailnum,
    event = dest
  )
write_rds(calendars, "calendars.rds")
