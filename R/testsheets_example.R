#' Get path to example file
#'
#' @param type Name of spreadsheet type. If `NULL`, the example file types will be listed.
#' @return a path or url to the specified resource
#' @export
#' @examples
#' testsheets_example()
#' testsheets_example("google sheets")
#' testsheets_example("excel")
testsheets_example <- function(type=NULL) {
  types <- c("excel", "google sheets")
  if (is.null(type) || !is.element(type, types)) {
    glue::glue("Available example file types are {glue::glue_collapse(types, \", \", last = \" and \")}.")
  } else if (type == "excel") {
    system.file("extdata", "testsheets_example.xlsx", package = "testsheets", mustWork = TRUE)
  } else if (type == "google sheets") {
    googledrive::drive_deauth()
    url <- "https://docs.google.com/spreadsheets/d/1vR1aUlKMGtZIJOZaHNk7kePgeYYrkhoy0PFmZxs8wt4/edit?usp=sharing"
    googledrive::drive_get(url)
  }
}
