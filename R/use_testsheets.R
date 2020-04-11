

#' Set up `testsheet` infrastructure
#'
#' Sets up data structures required to save a running list of testsheet source files.
#' @export
#'
#' @examples
#' use_testsheets()
use_testsheets <- function() {
  check_installed("testthat")
  check_installed("testsheets")
  check_installed("googledrive")
  check_installed("googlesheets4")

  testthat_path <- fs::path("tests", "testthat")
  testthat_file <- fs::path("tests", "testthat.R")
  if (!fs::dir_exists(testthat_path) || !fs::file_exists(testthat_file)) {
    usethis::ui_stop("File {usethis::ui_path(testthat_file)} doesn't exist. Use {usethis::ui_code('usethis::use_testthat()')} \\
                     to set up testing infrastructure")
  }

  if (is_package()) {
    use_dependency("testthat", "Suggests")
    use_dependency("testsheets", "Suggests")
    use_dependency("googledrive", "Suggests")
    use_dependency("googlesheets4", "Suggests")
  }

  # location of Rdata file
  spreadsheets_file <- fs::path("tests", ".spreadsheets.rds")
  sheets_file <- fs::path("tests", ".sheets.rds")
  # create an empty dribble
  spreadsheets <- googledrive::as_dribble()
  # empty list for sheet names
  sheets <- list()
  saveRDS(spreadsheets, file = spreadsheets_file, compress = FALSE)
  saveRDS(sheets, file = sheets_file, compress = FALSE)

  usethis::ui_todo(
    "Call {ui_code('googledrive::drive_auth()')} to authorize googledrive to view and manage \\
    your Drive files. By default, your user credentials are cached so they can be automatically \\
    refreshed, as necessary."
  )
  usethis::ui_todo(
    "Call {ui_code('googlesheets4::sheets_auth(token = drive_token())')} to direct googlesheets4 \\
    to use the same token as googledrive"
  )
}

#' @seealso Taken directly from usethis package at \url{https://github.com/r-lib/usethis/blob/d1d28c9a65fbea19099e9a5d448de59e06b8c1a0/R/utils.R}.
#' @keywords internal
check_installed <- function(pkg) {
  if (!is_installed(pkg)) {
    ui_stop("Package {ui_value(pkg)} required. Please install before re-trying.")
  }
}

#' @seealso Taken directly from usethis package at \url{https://github.com/r-lib/usethis/blob/d1d28c9a65fbea19099e9a5d448de59e06b8c1a0/R/utils.R}.
#' @keywords internal
is_installed <- function(pkg) {
  requireNamespace(pkg, quietly = TRUE)
}


#' @seealso Taken directly from usethis package at \url{https://github.com/r-lib/usethis/blob/fb6e390bf874462ffab803df2319f8a982a0848f/R/helpers.R}.
#' @keywords internal
use_dependency <- function(package, type, min_version = NULL) {
  stopifnot(rlang::is_string(package))
  stopifnot(rlang::is_string(type))

  if (package != "R" && !is_installed(package)) {
    ui_stop(c(
      "{ui_value(package)} must be installed before you can ",
      "take a dependency on it."
    ))
  }

  if (isTRUE(min_version)) {
    min_version <- utils::packageVersion(package)
  }
  version <- if (is.null(min_version)) "*" else paste0(">= ", min_version)

  types <- c("Depends", "Imports", "Suggests", "Enhances", "LinkingTo")
  names(types) <- tolower(types)
  type <- types[[match.arg(tolower(type), names(types))]]

  deps <- desc::desc_get_deps(proj_get())

  existing_dep <- deps$package == package
  existing_type <- deps$type[existing_dep]
  existing_ver <- deps$version[existing_dep]
  is_linking_to <- (existing_type != "LinkingTo" & type == "LinkingTo") |
    (existing_type == "LinkingTo" & type != "LinkingTo")

  # No existing dependency, so can simply add
  if (!any(existing_dep) || any(is_linking_to)) {
    ui_done("Adding {ui_value(package)} to {ui_field(type)} field in DESCRIPTION")
    desc::desc_set_dep(package, type, version = version, file = proj_get())
    return(invisible())
  }

  existing_type <- setdiff(existing_type, "LinkingTo")
  delta <- sign(match(existing_type, types) - match(type, types))
  if (delta < 0) {
    # don't downgrade
    ui_warn(
      "Package {ui_value(package)} is already listed in \\
      {ui_value(existing_type)} in DESCRIPTION, no change made."
    )
  } else if (delta == 0 && !is.null(min_version)) {
    # change version
    upgrade <- existing_ver == "*" || numeric_version(min_version) > version_spec(existing_ver)
    if (upgrade) {
      ui_done(
        "Increasing {ui_value(package)} version to {ui_value(version)} in DESCRIPTION"
      )
      desc::desc_set_dep(package, type, version = version, file = proj_get())
    }
  } else if (delta > 0) {
    # upgrade
    if (existing_type != "LinkingTo") {
      ui_done(
        "
        Moving {ui_value(package)} from {ui_field(existing_type)} to {ui_field(type)} \\
        field in DESCRIPTION
        "
      )
      desc::desc_del_dep(package, existing_type, file = proj_get())
      desc::desc_set_dep(package, type, version = version, file = proj_get())
    }
  }

  invisible()
}
