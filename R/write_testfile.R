
#' Write testdata to a file formatted for use with the testthat package.
#'
#' @param testdata tibble
#' @param func_name charater. The name of the function being tested. Typically the name of the sheet.
#' @param filename character (vector). The default is testsheet_<sheet>.R. The number of given
#' filenames must match the length of testdata.
#' @param filepath character. The defallt is the current working directory
#' @param overwrite boolean. The default is FALSE.
#' @import dplyr
#'
#' @export
#'
#' @examples
#' url <- testsheets_example("google sheets")
#' ss <- googledrive::drive_get(url)
#' testdata <- read_testsheet(ss, "sum")
#' write_testfile(testdata, "sum", filename="mycustomfile.R")
write_testfile <- function(testdata, func_name, filename=NULL, filepath=NULL, overwrite=FALSE) {

  connection <- open_file_connection(func_name, filename, filepath, overwrite)

  testdata <- testdata %>% select(-starts_with("user_"))  # discard user column

  # sequence through every row (in tibble form)
  for(i in seq(nrow(testdata))) {
    row  <- testdata[i, ]
    write_row(row, func_name, connection)
  }
  close(connection)
}

open_file_connection <- function(func_name, filename=NULL, filepath=NULL, overwrite=FALSE) {

  # default filename is the name of the test function
  if (is.null(filename)) {
    filename <- paste0("testsheet_", func_name, ".R")
  }

  # default path is cwd
  if (is.null(filepath)) {
    filepath <- getwd()
  }

  # open file connection
  fullpath <- file.path(filepath, filename)

  # create file
  created_file <- file.create(fullpath, overwrite=overwrite)
  # open connection
  connection <- file(fullpath, open = "w")
}

write_row <- function(row, func_name, connection) {

  # remove NA's
  clean_row <- row %>% dplyr::select_if(~any(!is.na(.)))

  # preprocess: separate parameters from expected output
  params <- dplyr::select(clean_row, dplyr::starts_with("param_"))
  params <- (dplyr::rename_at(params, dplyr::vars(dplyr::starts_with("param_")), ~ stringr::str_replace(., "param_", "")))
  expects <- dplyr::select(clean_row, dplyr::starts_with("expect_"))

  # test_that ...
  writeLines(paste0("test_that( ", row$test_that, ", {"), connection)

  # ...the function (as specified by the sheet title)...
  writeLines(paste0("\tactual <- ", func_name, "("), connection)

  # ...with the given parameters...
  param_names <- colnames(params)
  len <- length(param_names)
  if (len > 1) {
    for (i in seq(len - 1)) {
      param_name <- param_names[i]
      writeLines(paste0("\t\t", param_name, " = ", params[[param_name]], ","), connection)
    }
  }
  # last parameter shouldn't be followed by a comma so we deal with it outside the for loop
  param_name <- param_names[len]
  writeLines(paste0("\t\t", param_name, " = ", params[[param_name]]), connection)

  writeLines("\t)", connection)
  for (expect in colnames(expects)) {
    # split at the second underscore. Example "expect_lte_power" -> "expect_lte" and "power"
    words <- unlist(strsplit(expect, "_"))
    expect_function <- paste(words[1:2], collapse="_")
    variable_name <- paste0("actual$",paste(words[3:length(words)], collapse="_"))
    writeLines(paste0("\t", expect_function, "(", variable_name, ", ", expects[[expect]], ")"), connection)
  }
  writeLines("})\n", connection)
}
