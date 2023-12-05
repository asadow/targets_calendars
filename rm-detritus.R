fs::dir_ls(
  here::here(), 
  regexp = "html$", 
  recurse = TRUE
  ) |> 
  stringr::str_subset("renv", negate = TRUE) |>
  fs::file_delete()
