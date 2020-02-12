# when finished with project, give user interface with Shiny and submit
# create devault spreadsheet from roxygen

# google drive
drive_token <- googledrive::drive_auth()
googlesheets4::sheets_auth(token=googledrive::drive_token())

# local file
excel_file_name <- "data.xlsx"
sheets_file_name <- "Copy of Testing Database"
test_file_name <- "ABC123"

spreadsheet <- googledrive::drive_get(test_file_name)

print(spreadsheet)
# side code: in the future check for mime type to confirm either google sheet or excel sheet

spreadsheet <- get_spreadsheet_from_drive(spreadsheet)

names <- googlesheets4::sheets_sheet_names(spreadsheet)


sheet <- googlesheets4::read_sheet(spreadsheet, names[1])
