#' Get the names of the tabs that are nested under a given tab
#'
#' @param name A character string, the name of the tab
#'
#' @return A character vector
#' @export
getChildTabs <- function(name) {
  parent_dir <- dirname(shinydashtabs::findTab(name))
  children   <- list.dirs(parent_dir, recursive = FALSE, full.names = FALSE)
  return(children)
}
