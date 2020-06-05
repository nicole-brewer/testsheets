# no need for a new_sheets internal constructor because it doesn't take arguments
# that need validating
sheets <- function() {
  x <- tibble::tibble(
    sheet_name = character(),
    ss_name = character(),
    ss_id = character(),
    func = character(),
    last_updated = date()
  )
  class(x) <- c("sheets", class(x))
  return(x)
}

#print.sheets <- function(sheets) {
  #sheets <- sheets %>% dplyr::select(-ss_id)
  #print(sheets)
  #pillar::colonnade(sheets)
  #https://pillar.r-lib.org/reference/pillar_shaft.html
  #https://cli.r-lib.org/articles/rules-boxes-trees.html
#}

validate_sheets <- function(x) {
  stopifnot(inherits(x, "sheets"))

  if (!has_sheets_cols(x)) {
    missing_cols <- setdiff(sheets_cols, colnames(x))
    stop_collapse(
      c(
        "Invalid sheets. These required column names are missing:",
        missing_cols
      )
    )
  }

  if (!has_sheets_coltypes(x)) {
    mistyped_cols <- sheets_cols[!sheets_coltypes_ok(x)]
    stop_collapse(
      c(
        "Invalid sheets. These columns have the wrong type:",
        mistyped_cols
      )
    )
  }
}

sheets_cols <- c("name", "ss_id", "func", "last_updated")

has_sheets_cols <- function(x) {
  all(sheets_cols %in% colnames(x))
}

sheets_coltypes_ok <- function(x) {
  c(
    name = is.character(x$name),
    id = is.character(x$id),
    drive_resource = inherits(x$drive_resource, "list")
  )
}

has_sheets_coltypes <- function(x) {
  all(sheets_coltypes_ok(x))
}








