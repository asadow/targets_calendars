library(readxl)
library(tidyverse)
library(clock)

absent <- read_xls("data-raw/absent.xls")

absent <- absent |> 
  rename_with(snakecase::to_snake_case) |> 
  rename(employee_no = id)

# Remove month 0 and treat day of the week as day of the month

absent <- absent |> 
  filter(month_of_absence != 0) |> 
  mutate(
    year = 2019,
    tr_code = "SICK",
    date = date_build(year, month_of_absence, day_of_the_week),
    .keep = "unused"
  )

# Multiply employee's -----------------------------------------------------

repeat_data <- list() 

for (i in seq(2:18)) {
  repeat_data[[i]] <- absent |> 
    mutate(
      employee_no = employee_no * !!i
    )
}

absent <- bind_rows(repeat_data) |> bind_rows(absent)

# Multiply years ----------------------------------------------------------

repeat_data <- list() 

for (i in 2019:2022) {
  repeat_data[[i]] <- absent |> mutate(year = !!i)
}

absent <- bind_rows(repeat_data) |> bind_rows(absent)

absent |> qs::qsave("data/absent")
