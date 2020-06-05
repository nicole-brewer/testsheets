#' read_testsheets
#'
#' @param ss A [dribble](https://googledrive.tidyverse.org/reference/dribble.html) that contains metadata for a single file.
#' @param sheet_name The name of the sheet, or "tab", in the ss.
#'
#' @return Tibble containing the contents of the testsheet.
#' @export
#'
#' @examples
#'
read_sheet <- function(ss, sheet_name) {
  validate_ss(ss)
  sheet <- read_sheet_i(ss, sheet_name)
  validate_sheet(sheet, sheet_name)
}

read_sheet_i <- function(ss, sheet_name) {
  sheet <- googlesheets4::read_sheet(ss, sheet=sheet_name)
  sheet <- sheet %>%
    dplyr::select(-dplyr::starts_with("user_")) %>%  # discard user column
    dplyr::mutate_if(is.character, ~ paste0("\"", . , "\""))
  sheet <- sheet %>% dplyr::filter(dplyr::include == TRUE)  # discard rows where "include" is FALSE, and then discard include column
  # don't know what this is for
  sheet <- data.frame(lapply(sheet[, names(which(sapply(colnames(sheet), function(x) sum(grepl('c[(]', sheet[, x])) > 0)))], function(y) gsub("NA", "NULL", y)))
  sheet <- data.frame(lapply(sheet[, names(which(sapply(colnames(sheet), function(x) sum(grepl('c[(]', sheet[, x])) > 0)))], function(y) gsub('"', '', y)))
}
