#' Find the existing tab names
#'
#' @return A character vector
#' @export
#' @examples
#' getExistingTabs()
getExistingTabs <- function() {

  # find the tab location
  tab_loc <- shinydashtabs::getTabLocation()

  # find the file paths of any R files under the tabs directory
  # look at the yamls only, unconfigured tabs aren't considered
  paths <- list.files(tab_loc, pattern = "\\.yaml$", full.names = TRUE, recursive = TRUE)

  # extract the names according to the conventions of the scaffold
  # assign the names so we know the location of each tab
  names(paths) <- shinydashtabs::extractTabName(paths)

  return(paths)
}
