---
  title: "Get started with testsheets"
---

# connect to google drive
drive_token <- googledrive::drive_auth()
googlesheets4::sheets_auth(token=googledrive::drive_token())

# file name in Google Drive
file_name <- "Testing Database"

# get and verify spreadsheet
spreadsheet <- googledrive::drive_get(file_name)
verify_spreadsheet(spreadsheet)

names <- googlesheets4::sheets_sheet_names(spreadsheet)

for(sheet_name in names) {

  sheet <- googlesheets4::read_sheet(spreadsheet, sheet=sheet_name)
  if (nrow(sheet) <= 1) {
    stop_glue(
      "Dribble input must contain data.\n",
      "  * Actual input has {nrow(x)} rows."
    )
  }
  # discard any confounding user variables
  sheet <- dplyr::select(sheet, -starts_with("user_"))
  sheet <- dplyr::mutate_if(sheet, is.character, function(x) paste0("\"",x ,"\"" ))

  testsheet <- file.path("/Users/nicolebrewer/Repos/work/SuperPowerFork/tests/testthat", paste0("testsheet_", sheet_name, ".R"))
  created <- file.create(testsheet, overwrite=TRUE)
  connection <- file(testsheet, open = "w")
  #write_testsheet(sheet, sheet_name, connection)

  write_testsheet(sheet, sheet_name, connection)
  close(connection)
}

