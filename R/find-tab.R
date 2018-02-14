#' Find an existing tab
#'
#' @param name The name of the tab to find the location for
#' @param tabs Where to start looking
#'
#' @return A filepath of the location of that tab
#' @export
findTab <- function(name, tabs = 'ui/body/tabs') {
  if (!dir.exists(tabs)) {
    stop(paste(tabs, "does not exist!"))
  }

  existing_tabs <- shinytabconstructor::getExistingTabs(tabs)
  if (length(existing_tabs) > 0L) {
    return(unname(existing_tabs[name]))
  } else {
    return(NA)
  }
}
