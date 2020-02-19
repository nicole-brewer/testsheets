# when finished with project, give user interface with Shiny and submit
# create devault spreadsheet from roxygen

# google drive
drive_token <- googledrive::drive_auth()
googlesheets4::sheets_auth(token=googledrive::drive_token())

# local file
file_name <- "data.xlsx"
file_name <- "Copy of Testing Database"
file_name <- "ABC123"
file_name <- "Testing Database"


spreadsheet <- googledrive::drive_get(file_name)

# side code: in the future check for mime type to confirm either google sheet or excel sheet

# spreadsheet <- get_spreadsheet_from_drive(spreadsheet)

names <- googlesheets4::sheets_sheet_names(spreadsheet)
sheet_name <- names[1]
sheet <- googlesheets4::read_sheet(spreadsheet, sheet=sheet_name)

# discard any confounding user variables
params <- dplyr::select(sheet, starts_with("param_"))
# TODO: start here. rename tibble columns to remove param
# or maybe do that in the writing of the testsheet



# for each row
row_tbl <- sheet[1, ]
row_list <- as.list(sheet[1, ])

write_testsheet_file <- function(testsheet_filename) {
  testsheets_file <- paste0("testsheets_", function_name)
  connection <- file(testsheets_file)
  # for each testcase in tibble
  #   write_testcase

  write_testcase <- function(tibble) {
    writeLines(paste0("test_that(\"", test_that, "\", {"))
    writeLines(paste0("\tactual <- ", function_name, "("))
    for (input_parameter, key, value in parameters) {
      writeLines(paste0("\t\t", key, " = ", value, ","))
    }
    writeLines("\t)")
    for (expect_function, var, value in expectations) {
      writeLines(paste0("\t", expect_function, "(", var, ", ", value, ")"))
    }
    writeLines("})")
  }



  close(connection)
}


