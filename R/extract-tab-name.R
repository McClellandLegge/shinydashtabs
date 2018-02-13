#' Extract the tab name from the file name
#'
#' @param path An .R or .yaml file path
#'
#' @return A character string
#' @export
#' @examples
#' extractTabName("a.dot.delimited.name.tabname.R")
extractTabName <- function(path) {

  # check that this is actually an R file
  non_r <- grep("(\\.R|\\.yaml)$", path, invert = TRUE, value = TRUE)
  if (length(non_r) > 0L) {
    nar <- "The following files don't conform to conventions -- should you be trying to create a tab with them?"
    msg <- paste0(nar, "\n", paste0(non_r, collapse = "\n"))
    stop(msg)
  }

  # the convention is that the last [a-z_]+ string in the dot delimited name
  # is the tab name
  gsub(".*\\.([a-z0-9_]+)(\\.R|\\.yaml)$", "\\1", basename(path))
}
