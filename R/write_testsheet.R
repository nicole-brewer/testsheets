#' Title
#'
#' @param sheet_name
#' @param filename
#' @param filepath
#' @param overwrite
#'
#' @return
#' @export
#'
#' @examples
write_testsheet <- function(sheet_name, filename=NULL, filepath=NULL, overwrite=FALSE) {

  require(usethis)
  if (is.null(filename)) filename <- paste0('test_', sheet_name, '.R')
  if (is.null(filename)) filepath <- paste0(gsub('//demo', '', getwd()), '/tests/testthat')

  spreadsheet <- googledrive::drive_get('Testing Database')
  validate_spreadsheet(spreadsheet)
  validate_sheet(sheet_name)
  connection <- open_file_connection(sheet_name, filename, filepath, overwrite)
  sheet <- read_testsheet_i(spreadsheet, sheet_name)

  list_cols <- names(which(sapply(colnames(sheet), function(x) sum(grepl('c[(]', sheet[, x])) > 0)))
  sheet <- data.frame(lapply(sheet[, list_cols], function(y) gsub("NA", "NULL", y)))
  sheet <- data.frame(lapply(sheet[, list_cols], function(y) gsub('"', '', y)))

  write_testsheet_i(sheet, sheet_name, connection)

}

open_file_connection <- function(sheet_name, filename=NULL, filepath=NULL, overwrite=FALSE) {

  # default filename is the name of the sheet
  if (is.null(filename)) {
    filename <- paste0('testsheet_', sheet_name, '.R')
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

write_testsheet_i <- function(sheet, sheet_name, connection) {

  # sequence through every row (in tibble form)
  for(i in seq(nrow(sheet))) {
    row  <- sheet[i, ]
    write_row(row, sheet_name, connection)
  }
  # transpose to get lists of row variables
  # and iterate through each row
  close(connection)
}

write_row <- function(row, sheet_name, connection) {
  clean_row <- row %>% dplyr::select_if(~any(!is.na(.)))
  params <- dplyr::select(clean_row, starts_with("param_"))
  params <- (dplyr::rename_at(params, dplyr::vars(starts_with("param_")),
                              ~stringr::str_replace(., "param_", "")))
  expects <- dplyr::select(clean_row, starts_with("expect_"))
  writeLines(paste0("test_that( ", row$test_that, ", {"), connection)
  writeLines(paste0("\tactual <- ", sheet_name, "("), connection)
  param_names <- colnames(params)
  len <- length(param_names)
  for (i in seq(len - 1)) {
    param_name <- param_names[i]
    writeLines(paste0("\t\t", param_name, " = ", params[[param_name]],
                      ","), connection)
  }
  param_name <- param_names[len]
  writeLines(paste0("\t\t", param_name, " = ", params[[param_name]]),
             connection)
  writeLines("\t)", connection)
  for (expect in colnames(expects)) {
    words <- unlist(strsplit(expect, "_"))
    expect_function <- paste(words[1:2], collapse = "_")
    variable_name <- paste0("actual$", paste(words[3:length(words)],
                                             collapse = "_"))
    writeLines(paste0("\t", expect_function, "(", variable_name,
                      ", ", expects[[expect]], ")"), connection)
  }
  writeLines("})\n", connection)
}


