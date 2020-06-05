
#' Get spreadsheet from Google Drive
#'
#' @param file_dribble a dribble containing a single googledrive file
#'
#' @return spreadsheet
#' @export
get_spreadsheet_from_drive <- function(file_dribble) {

  ## *taken from googlesheets4*
  if (nrow(file_dribble) != 1) {
    stop_glue(
      "Dribble input must have exactly 1 row.\n",
      "  * Actual input has {nrow(x)} rows."
    )
  }

  # Get mime types for Google Sheets and Excel spreadsheets
  googlesheets_mime_type <- googledrive::drive_mime_type("spreadsheet")
  xls_mime_type <- googledrive::drive_mime_type("xls")
  xlsx_mime_type <- googledrive::drive_mime_type("xlsx")

  # get mime type
  mime_type <- googledrive::drive_reveal(file_dribble, "mime_type")[["mime_type"]]

  # check that the given file matches one of these types and construct
  # corresponding spreadsheet
  if (identical(mime_type, googlesheets_mime_type)) {
    spreadsheet <- googlesheets4::sheets_get(file_dribble)
  } else if (identical(mime_type, xls_mime_type)) {
    spreadsheet <- readxl::read_xls(file_dribble)
  } else if (identical(mime_type, xlsx_mime_type)) {
    spreadsheet <- readxl::read_xlsx(file_dribble)
  } else {
    stop_glue(
      "Dribble input must refer to a Google Sheet or Excel spreadsheet i.e. a file with MIME ",
      "type {sq(google_sheets_mime_type)}, {sq(xls_mime_type)}, or {sq(xlsx_mime_type)}.\n",
      "  * File id: {sq(file_dribble$id)}\n",
      "  * File name: {sq(file_dribble$name)}\n",
      "  * MIME TYPE: {sq(mime_type)}"
    )
  }
  return(spreadsheet)
}








