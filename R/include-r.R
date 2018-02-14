#' Recursively source R scripts and return the values
#'
#' @param path A path to an R script
#' @param singe_as_list A Boolean. Should a single sourced value be returned
#'     as list? Useful for server functions
#' @param ... Additional argument to \code{list.files}
#'
#' @return A list if more than one file sourced, otherwise the value itself
#' @export
includeR <- function(path, single_as_list = FALSE, ...)
  # like `shiny::include_html` and friends, this sources
  # an R script and returns the value
{

  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("`purrr` needed for this function to work. Please install it.", call. = FALSE)
  }

  if (dir.exists(path)) {
    path_ <- list.files(path, pattern = ".R$", full.names = TRUE, ...)
  } else if (file.exists(path)) {
    path_ <- path
  } else {
    msg   <- paste0("'", path, "' does not exist!")
    stop(msg, call. = FALSE)
  }

  objs <- purrr::map(path_, function(path) source(path, local = TRUE)$value)
  if (length(objs) == 1L & single_as_list == FALSE) {
    return(objs[[1L]])
  } else {
    return(objs)
  }
}
