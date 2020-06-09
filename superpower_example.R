# install from git repository
# devtools::install_github("nicole-brewer/testsheets")

# connect to google drive
drive_token <- googledrive::drive_auth()
googlesheets4::gs4_auth(token=googledrive::drive_token())

# file name in Google Drive
file_name <- "Testing Database"

# get and verify spreadsheet
spreadsheet <- googledrive::drive_get(file_name)

# get file path of this script
filepath<-dirname(rstudioapi::getActiveDocumentContext()$path)
setwd(filepath)
setwd("../testthat")
filepath <- getwd()

## CHANGE ME TO THE CORRECT SHEET NAME
sheet_name_vec <- c("powerTtest", "powerRegression", "powerANOVAS", "powerANCOVA_multiway")
for (sheet_name in sheet_name_vec) {
  testsheets::create_testfile(spreadsheet, sheet_name,
                              filename = paste0('test_', sheet_name, '.R'), filepath=filepath, overwrite = TRUE)
}

