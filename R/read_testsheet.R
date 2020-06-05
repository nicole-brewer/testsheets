#' Reading a testsheet into a testdata tibble
#'
#' @param ss dribble or filepath.
#' @param sheet character. The name of the sheet to be read.
#' @param keep_user_columns boolean. Keeps user type columns in testdata. Note that user
#' columns will still be removed upon writing testdata to a testfile.
#'
#' @importFrom rlang .data
#' @return tibble containing testdata.
#' @export
#'
#' @examples
#' googledrive::drive_deauth()
#' googlesheets4::gs4_deauth()
#' url <- testsheets_example("google sheets")
#' ss <- googledrive::drive_get(url)
#' testdata <- read_testsheet(ss, "mean")
read_testsheet <- function(ss, sheet, keep_user_columns=TRUE) {
  if (googledrive::is_dribble(ss)) {
    googledrive::confirm_single_file(ss)
    testdata <- read_google_testsheet(ss, sheet)
  } else if (class(ss) == "character") {
    if (!file.exists(ss)) {
      stop_glue("The file {ss} does not exist.")
    } else {
      testdata <- read_excel_testsheet(ss, sheet)
    }
  }

  if(!keep_user_columns) {
    testdata <- testdata %>% dplyr::select(-dplyr::starts_with("user_"))  # discard user column
  }
  return(testdata)
}

#' Reading all testsheets in one file into a vector of testdata tibbles
#'
#' @param ss dribble or filepath.
#'
#' @return a vector tibbles containing testdata for each sheet in a ss
#' @export
#'
#' @examples
#' url <- testsheets_example("google sheets")
#' ss <- googledrive::drive_get(url)
#' testdata <- read_testsheets(ss)
read_testsheets <- function(ss) {
  if (googledrive::is_dribble(ss)) {
    googledrive::confirm_single_file(ss)
    sheet_names <- googlesheets4::sheet_names(ss)
    for (sheet in sheet_names) {
      read_google_testsheet(ss, sheet)
    }
  } else if (class(ss) == "character") {
    if (!file.exists(ss)) {
      stop_glue("The file {ss} does not exist.")
    } else if (is.na(readxl::excel_format(ss))) {
      stop_glue("The file {ss} exists but is not an excel file.")
    } else {
      sheet_names <- readxl::excel_sheets(ss)
      read_excel_testsheet(ss, sheet)
    }
  }
}

read_google_testsheet <- function(ss, sheet) {
  names <- googlesheets4::sheet_names(ss)
  sheet %>% confirm_sheet_exists(names)
  data <- sheet %>% googlesheets4::read_sheet(ss, .)
  testdata <- data %>% create_testdata()
}

read_excel_testsheet <- function(path, sheet) {
  names <- readxl::excel_sheets(path)
  sheet %>% confirm_sheet_exists(names)
  data <- sheet %>% readxl::read_excel(path, .)
  testdata <- data %>% create_testdata()
}

create_testdata <- function(data) {
  data <- data %>%
    dplyr::mutate_if(is.character, ~ paste0("\"", ., "\"")) %>%
    dplyr::filter(.data$include == TRUE) %>%  # discard rows where "include" is FALSE, and then discard include column
    dplyr::select(-dplyr::matches("passing"))
}

confirm_sheet_exists <- function(sheet, names) {
  if (!is.element(sheet, names)) {
    stop_glue("There is no sheet \"{sheet}\" in the spreadsheet.")
  }
}
