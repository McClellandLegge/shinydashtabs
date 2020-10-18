#' Get name of tab based on file name
#'
#' @return A character string or \code{NULL}
#' @export
thisTabName <- function() {
  path <- parent.frame(3)$ofile

  if (!is.null(path)) {
    # extract the tab name from the established conventions
    return(shinydashtabs::extractTabName(path))
  } else {
    warning("This function should only be run by 'shiny', it will return 'NULL' any other time")
    return(NULL)
  }
}
