#' Find an existing tab
#'
#' @param name The name of the tab to find the location for
#'
#' @return A filepath of the location of that tab
#' @export
findTab <- function(name) {
  existing_tabs <- shinydashtabs::getExistingTabs()
  return(ifelse(length(existing_tabs) > 0L, unname(existing_tabs[name]), NA))
}
