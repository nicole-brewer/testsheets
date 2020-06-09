#' @description \code{testsheets} package
#'
#' @docType package
#' @name testthat
#' @importFrom dplyr %>%
#' @importFrom purrr %||%
#' @keywords internal
NULL

## quiets concerns of R CMD check re: the .'s that appear in pipelines
if(getRversion() >= "2.15.1")  utils::globalVariables(c("."))
