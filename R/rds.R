
print_sheets <- function() {
  print(read_sheets())
}

read_sheets <- function() {
  sheets <- readRDS(fs::path("tests", ".sheets.rds"))
}

save_sheets <- function(sheets) {
  saveRDS(sheets, fs::path("tests", ".sheets.rds"), compress = FALSE)
}

read_spreadsheets <- function() {
  spreadsheets <- readRDS(fs::path("tests", ".spreadsheets.rds"))
}


save_spreadsheets <- function(spreadsheets) {
  saveRDS(spreadsheets, fs::path("tests", ".spreadsheets.rds"), compress = FALSE)
}

print_spreadsheets <- function() {
  print(read_spreadsheets())
}

add_spreadsheet <- function(ss) {
  spreadsheets <- read_spreadsheets()
  id_match <- spreadsheets %>% dplyr::filter(id == ss$id)
    if (nrow(id_match) == 1) {
      spreadsheets <- spreadsheets %>% dplyr:: filter(-(id == ss$id))
      spreadsheets <- spreadsheets %>% tibble::add_row(ss)
    } else if (nrow(id_match) == 0) {
      spreadsheets <- spreadsheets %>% tibble::add_row(ss)
    } else {
      stop_glue("Unexpected internal error has occured in function {usethis::ui_code('add_spreadsheet')} \\
        {usethis::ui_path('rds.R')}")
    }
  spreadsheets <- tibble::add_row(spreadsheet, ss)
  save_spreadsheets(spreadsheets)
}

remove_spreadsheet <- function(sheet_name) {
  spreadsheets <- read_spreadsheets()
  spreadsheets <- spreadsheets %>% dplyr::filter(-(sheet_name == sheet_name))
}











