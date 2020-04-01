
write_testsheet <- function(spreadsheet, sheet_name, filename=NULL, filepath=NULL, overwrite=FALSE) {
  validate_spreadsheet(spreadsheet)
  validate_sheet(sheet_name)
  sheet <- googlesheets4::read_sheet(spreadsheet, sheet=sheet_name)
  connection <- open_file_connection(sheet_name, filename, filepath, overwrite)
  sheet <- read_testhsheet_i(sheet, sheet_name)
  write_testsheet_i(sheet, sheet_name, connection)
}

open_file_connection <- function(sheet_name, filename=NULL, filepath=NULL, overwrite=FALSE) {

  # default filename is the name of the sheet
  if (is.null(filename)) {
    filename <- paste0(sheet_name, ".R")
  }

  # default path is cwd
  if (is.null(filepath)) {
    filepath <- getwd()
  }

  # open file connection
  fullpath <- file.path(filepath, filename)
  print(fullpath)

  # create file
  created_file <- file.create(fullpath, overwrite=overwrite)
  # open connection
  connection <- file(fullpath, open = "w")
}

write_testsheet_i <- function(sheet, sheet_name, connection) {

  # for each testcase in tibble
  #   write_testcase
  for(i in 1:nrow(sheet)) {
    # get a single row
    row  <- sheet[i, ]

    # remove NA's
    clean_row <- row %>% dplyr::select_if(~any(!is.na(.)))
    # preprocess: separate parameters from expected output
    params <- dplyr::select(clean_row, starts_with("param_"))
    params <- (dplyr::rename_at(params, dplyr::vars(starts_with("param_")), ~ stringr::str_replace(., "param_", "")))
    expects <- dplyr::select(clean_row, starts_with("expect_"))

    # test_that ...
    writeLines(paste0("test_that( ", row$test_that, ", {"), connection)

    # ...the function (as specified by the sheet title)...
    writeLines(paste0("\tactual <- ", sheet_name, "("), connection)

    # ...with the given parameters...
    for (param in colnames(params)) {
      writeLines(paste0("\t\t", param, " = ", params[[param]], ","), connection)
    }
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
  close(connection)
}


