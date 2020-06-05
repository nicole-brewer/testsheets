
#' Use a spreadsheet to create files for use with the testthat package.
#'
#' @param ss dribble or filepath.
#' @param sheet character (vector). The names of the sheets to be read.
#' @param manipulator a function that manipulates the testdata once it has been read from the spreadsheet
#' @param filename character (vector). The default is testsheet_<sheet>.R. The number of given
#' filenames must match the length of testdata.
#' @param filepath character. The defallt is the current working directory
#' @param overwrite boolean. The default is FALSE.
#'
#' @export
#'
#' @examples
#'
#' ss_path <- testsheets_example("excel")
#' drop_param_y <- function(testdata) {
#'   testdata <- testdata %>% dplyr::select(-dplyr::starts_with("param_y"))
#' }
#' filename <- "testsheet_sum_x_only.R"
#' create_testfile(ss_path, sheet = "sum", manipulator = drop_param_y, filename=filename)
create_testfile <- function(ss, sheet, manipulator=NULL, filename=NULL, filepath=NULL, overwrite=FALSE) {
  testdata <- read_testsheet(ss, sheet)
  if (!is.null(manipulator)) {
    testdata <- testdata %>% manipulator()
  }
  write_testfile(testdata, sheet, filename, filepath, overwrite)
}
