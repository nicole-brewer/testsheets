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
create_testfile(sum_ss, sheet = "sum")

## -----------------------------------------------------------------------------
library(testsheets)

# Obtain the path of an example testsheet
path <- testsheets_example("excel")

# create testdata from the sheet called "sum"
testdata <- read_testsheet(path, sheet = "sum")

# modify the testdata tibble in some desired way
change_testdata <- function(testdata) {
  message("Testdata has been modified in some way!")
  testdata <- testdata
}

testdata <- testdata %>% change_testdata()

# write the testdata to a testfile
write_testfile(testdata, "sum")

## -----------------------------------------------------------------------------
library(testsheets)

# Obtain the path of an example testsheet
path <- testsheets_example("excel")

# define our "manipulator" function
change_testdata <- function(testdata) {
  message("Testdata has been modified in some way!")
  testdata <- testdata
}

create_testfile(path, "sum", manipulator=change_testdata)

