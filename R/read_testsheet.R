read_testsheet <- function(spreadsheet, sheet_name) {
  validate_spreadsheet(spreadsheet)
  sheet <- read_testsheet_i(spreadsheet, sheet_name)
  validate_sheet(sheet, sheet_name)
}

read_testsheet_i <- function(spreadsheet, sheet_name) {
  sheet <- googlesheets4::read_sheet(spreadsheet, sheet=sheet_name)
  sheet <- sheet %>%
    dplyr::select(-starts_with("user_")) %>%  # discard user column
    dplyr::mutate_if(is.character, ~ paste0("\"", . , "\""))
  sheet <- sheet %>% dplyr::filter(include == TRUE)  # discard rows where "include" is FALSE, and then discard include column
}
