% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/write_testfile.R
\name{write_testfile}
\alias{write_testfile}
\title{Write testdata to a file formatted for use with the testthat package.}
\usage{
write_testfile(
  testdata,
  func_name,
  filename = NULL,
  filepath = NULL,
  overwrite = FALSE
)
}
\arguments{
\item{testdata}{tibble}

\item{func_name}{charater. The name of the function being tested. Typically the name of the sheet.}

\item{filename}{character (vector). The default is testsheet_<sheet>.R. The number of given
filenames must match the length of testdata.}

\item{filepath}{character. The defallt is the current working directory}

\item{overwrite}{boolean. The default is FALSE.}
}
\description{
Write testdata to a file formatted for use with the testthat package.
}
\examples{
ss <- testsheets_example("google sheets")
testdata <- read_testsheet(ss, "sum")
write_testfile(testdata, "sum", filename="mycustomfile.R")
}
