#' Get name of tab based on file name
#'
#' @return A character string or \code{NULL}
#' @export
thisTabName <- function() {
  path <- parent.frame(3)$ofile

  if (!is.null(path)) {
    # extract the tab name from the established conventions
    return(shinytabconstructor::extractTabName(path))
  } else {
    return(NULL)
  }
}
