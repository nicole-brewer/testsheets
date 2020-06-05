update <- function() {
  s <- read_sheets()
  ss <- read_spreadsheets()
  for(i in seq(nrow(s))) {
    row  <- s[i, ]
    spreadsheet <- dplyr::filter(ss, id == row$ss_id)
    write_testsheet(spreadsheet, sheet_name = row$sheet_name, filepath=usethis::proj_path("tests", "testthat"))
    #spreadsheet <- s$ss_id
  }
}

# TODO: also remove from spreadsheet if only one using it
remove <- function(sheet_name) {
  sheets <- read_sheets()
  sheets <- sheets %>% dplyr::filter(!(sheet_name == sheet_name))
}

ls <- function() {
  sheets <- read_sheets()
  print(sheets)
}


add <- function(sheet_name, ss, func = NULL, last_updated = NULL) {

  validate_spreadsheet(ss)
  s <- read_sheets()

  # check that sheet is in spreadsheet
  if (!(sheet_name %in% googlesheets4::sheet_names(ss))) {
    stop_glue("The sheet \"{sheet_name}\" doesn't exist in the spreadsheet {ss$name}.")
  }

  # check for preexisting sheet in "sheets" with the same name
  preexisting <- dplyr::filter(s, sheet_name == sheet_name)
  if (nrow(preexisting) > 0) {
    overwrite <- usethis::ui_yeah("A sheet by the name {sheet_name} already exists.\n \\
                     {preexisting}\n Are you sure you want to overwrite?")
    if(overwrite) {
      if (nrow(preexisting) == 1) {
        s <- sheets()
      } else {
        s <- s %>% dplyr::filter(!(sheet_name == sheet_name))
      }
    } else {
      stop()
    }
  }

  #default values
  if (is.null(func)) {
    func <- sheet_name
  }
  if (is.null(last_updated)) {
    last_updated <- date()
  }
  s <- s %>% tibble::add_row(sheet_name, ss_id = ss$id, func = func, last_updated)
  add_spreadsheet(ss)
  save_sheets(s)
}
