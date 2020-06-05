## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## -----------------------------------------------------------------------------
# Retrieve the google sheet
library(googledrive)
library(testsheets)

# indicate there is no need for an access token since we are accessing
# a read-only sheet via a public link
googledrive::drive_deauth()

# get document metadata from Google Drive
example_sheet_url <- testsheets::testsheets_example("google sheets")
sum_ss <- googledrive::drive_get(example_sheet_url)

# Load the "sum" sheet into a dribble
#sum_testsheet <- read_testsheet(sum_ss, sheet = "sum")

