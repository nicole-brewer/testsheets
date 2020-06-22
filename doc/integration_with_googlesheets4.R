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
dribble <- testsheets::testsheets_example("google sheets")

# Load the "sum" sheet into a tibble
sum_testsheet <- read_testsheet(dribble, sheet = "sum")

