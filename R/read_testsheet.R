read_testsheet <- function(sheet, sheet_name) {
  validate_spreadsheet(spreadsheet)
  validate_sheet(sheet, sheet_name)
  read_testsheet_i(sheet, sheet_name)
}

read_testhsheet_i <- function(sheet, sheet_name) {
  # discard user columns
  sheet <- dplyr::select(sheet, -starts_with("user_"))
  # discard rows where "include" is FALSE, and then discard include column
  sheet <- dplyr::filter(sheet, include == TRUE)
  sheet <- dplyr::select(sheet, -include)
}
