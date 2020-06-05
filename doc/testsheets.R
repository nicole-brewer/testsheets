## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ---- eval = FALSE------------------------------------------------------------
#  # install.packages("devtools")
#  devtools::install_github("nicole-brewer/testsheets")

## -----------------------------------------------------------------------------
# Retrieve the google sheet
library(googledrive)
library(testsheets)

# indicate there is no need for an access token since we are accessing
# a read-only sheet via a public link
googledrive::drive_deauth()

# get 
sum_ss <- googledrive::drive_get("https://docs.google.com/spreadsheets/d/1vR1aUlKMGtZIJOZaHNk7kePgeYYrkhoy0PFmZxs8wt4/edit?usp=sharing")

# Load the "sum" sheet into a dribble
#create_testsheet(sum_ss, sheet = "sum")

## -----------------------------------------------------------------------------


# create testdata from temporary xlsx file
#testdata <- read_testsheet(sum_ss, sheet = "sum")

# modify the testdata tibble in some desired way
change_testdata <- function(testdata) {
  print('make modifications here!')
  testdata <- testdata
}
#testdata <- testdata %>% change_testdata()

# write the testdata to a testfile
#write_testsheet(testdata)

