id <- "1:1"
data_type <- "2:2"
var_type <- "3:3"
#var_name <- "4:4"

get_dataframes <- function(spreadsheet) {
  names <- googlesheets4::sheets_sheet_names(spreadsheet)
  for (name in names) {
    sheet <- googlesheets4::read_sheet(spreadsheet, name)
    # transform to test
  }

}

sheet_to_testthat_file <- function(sheet) {

  connection <- file(paste("testsheets_",names[1]))

writeLines("test_that(\"id=2: give me a more telling name\", {")
writeLines()


close(connection)
}

create_dataframes <- function(spreadsheet, sheet_name) {
  range <- paste0(sheet_name,"!",data_type)
  print(range)
  data_types <- googlesheets4::read_sheet(spreadsheet, range=range)
}

create_dataframes(spreadsheet, names[1])
