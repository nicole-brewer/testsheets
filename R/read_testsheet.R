#' read_testsheets
#'
#' @param spreadsheet A [dribble](https://googledrive.tidyverse.org/reference/dribble.html) that contains metadata for a single file.
#' @param sheet_name The name of the sheet, or "tab", in the spreadsheet.
#'
#' @return Tibble containing the contents of the testsheet.
#' @export
#'
#' @examples
#'
read_testsheet <- function(spreadsheet, sheet_name) {
  validate_spreadsheet(spreadsheet)
  sheet <- read_testsheet_i(spreadsheet, sheet_name)
  validate_sheet(sheet, sheet_name)
}

read_testsheet_i <- function(spreadsheet, sheet_name) {
  sheet <- googlesheets4::read_sheet(spreadsheet, sheet=sheet_name)
  sheet <- sheet %>%
    dplyr::select(-dplyr::starts_with("user_")) %>%  # discard user column
    dplyr::mutate_if(is.character, ~ paste0("\"", . , "\""))
  sheet <- sheet %>% dplyr::filter(dplyr::include == TRUE)  # discard rows where "include" is FALSE, and then discard include column
  # don't know what this is for
  sheet <- data.frame(lapply(sheet[, names(which(sapply(colnames(sheet), function(x) sum(grepl('c[(]', sheet[, x])) > 0)))], function(y) gsub("NA", "NULL", y)))
  sheet <- data.frame(lapply(sheet[, names(which(sapply(colnames(sheet), function(x) sum(grepl('c[(]', sheet[, x])) > 0)))], function(y) gsub('"', '', y)))
}
