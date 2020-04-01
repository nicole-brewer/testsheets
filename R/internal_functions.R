# TODO: validate except functions
# names and value types
# TODO: make sure there is at least one working row


validate_spreadsheet <- function(spreadsheet) {

  # confirm spreadsheet is a dribble
  #googledrive::confirm_dribble(spreadsheet)

  # *taken from googlespreadsheet4*
  # confirm the dribble contains only one file
  if (nrow(spreadsheet) != 1) {
    stop_glue(
      "Dribble input must have exactly 1 file.\n",
      "  * Actual input has {nrow(x)} files."
    )
  }

  # confirm the file is of type spreadsheet
  googlespreadsheet_mime_type <- googledrive::drive_mime_type("spreadsheet")
  mime_type <- googledrive::drive_reveal(spreadsheet, "mime_type")[["mime_type"]]
  if (!identical(mime_type, googlespreadsheet_mime_type)) {
    stop_glue(
      "File must be of mime type {googlespreadsheet_mime_type}.\n",
      "   * Actual input is of type {mime_type}."
    )
  }
}

validate_sheet <- function(spreadsheet, sheet_name) {
  #names <- googlesheets4::sheets_sheet_names(spreadsheet)
  #if (!is.element(sheet_name, names)) {
  #  stop_glue("No sheet named {sheet_name} exists in this spreadsheet.")
  # }
}

validate_testsheet <- function(sheet) {

  # sheet column names
  columns <- colnames(sheet)

  # check that the tibble has a test_that column
  if (!is.element("test_that", columns)) {
    stop_glue("Required column \"test_that\" is absent from the testsheet.")
  }

  # check that test sheet contains at least one parameter and one expect function
  required_cols <- c("param_", "expect_")
  for (required in required_cols) {
    present <- FALSE
    for (column in columns) {
      if(grepl(required, column, fixed=TRUE)) {
        present <- TRUE
      }
    }
    if(!present) {
      stop_glue("At least one column with the prefix \"{required}\" s required.")
    }
  }
}




