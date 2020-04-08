---
  title: "Get started with testsheets"
---

# connect to google drive
drive_token <- googledrive::drive_auth()
googlesheets4::sheets_auth(token=googledrive::drive_token())

# file name in Google Drive
file_name <- "Testing Database"

mime_type <- googledrive::drive_mime_type("spreadsheet")

# get and verify spreadsheet
spreadsheet <- googledrive::drive_find(file_name, type=mime_type)
sheet_name <- "powerTtest"
write_testsheet(sheet)



