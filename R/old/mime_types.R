

#' Get MIME type
#'
#' @param type
#'
#' @description This is a helper to determine which MIME type should be used
#' for a file. Three types of input are acceptable:
#'   - "google spreadsheet"
#'   - "xls"
#'   - "xlsx"
#'   - "csv"
#'   * Native Google Drive file types. Important examples:
#'     - "document" for Google Docs
#'     - "folder" for folders
#'     - "presentation" for Google Slides
#'     - "spreadsheet" for Google Sheets
#'   * File extensions, such as "pdf", "csv", etc.
#'   * MIME types accepted by Google Drive (these are simply passed through).
#'
#' @param type Character. File type denoted by either a name or extension.
#'
#' @return Character. MIME type.
#'
#' @examples
#' ## get the mime type for Google spreadsheet
#' drive_mime_type("google spreadsheet")
#'
#' ## get the mime type for Excel workbook
#' get_mime_type("xls")
#' @export
get_mime_type <- function(type) {
  if (type == "google spreadsheet") {
    type <- "spreadsheet"
  }
  mime_type <- googledrive::drive_mime_type(type)
}
