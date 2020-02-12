# This file was taken directly from [tidyverse/googlesheets4](https://github.com/tidyverse/googlesheets4/blob/37dac4e050a654df69f658ddb97d9110aca1a140/R/glue.R)

sq <- function(x) glue::single_quote(x)
bt <- function(x) glue::backtick(x)
dq <- function(x) encodeString(x, quote = '"')

fr <- function(x) format(x, justify = 'right')
fl <- function(x) format(x, justify = 'left')

stop_glue <- function(..., .sep = "", .envir = parent.frame(),
                      call. = FALSE, .domain = NULL) {
  stop(
    glue::glue(..., .sep = .sep, .envir = .envir),
    call. = call., domain = .domain
  )
}

stop_glue_data <- function(..., .sep = "", .envir = parent.frame(),
                           call. = FALSE, .domain = NULL) {
  stop(
    glue::glue_data(..., .sep = .sep, .envir = .envir),
    call. = call., domain = .domain
  )
}

stop_collapse <- function(x) stop(glue::glue_collapse(x, sep = "\n"), call. = FALSE)

warning_glue <- function(..., .sep = "", .envir = parent.frame(),
                         call. = FALSE, .domain = NULL) {
  warning(
    glue::glue(..., .sep = .sep, .envir = .envir),
    call. = call., domain = .domain
  )
}

warning_glue_data <- function(..., .sep = "", .envir = parent.frame(),
                              call. = FALSE, .domain = NULL) {
  warning(
    glue::glue_data(..., .sep = .sep, .envir = .envir),
    call. = call., domain = .domain
  )
}

warning_collapse <- function(x) warning(glue::glue_collapse(x, sep = "\n"))

message_glue <- function(..., .sep = "", .envir = parent.frame(),
                         .domain = NULL, .appendLF = TRUE) {
  message(
    glue::glue(..., .sep = .sep, .envir = .envir),
    domain = .domain, appendLF = .appendLF
  )
}

message_glue_data <- function(..., .sep = "", .envir = parent.frame(),
                              .domain = NULL) {
  message(
    glue::glue_data(..., .sep = .sep, .envir = .envir),
    domain = .domain
  )
}

message_collapse <- function(x) message(glue::glue_collapse(x, sep = "\n"))
