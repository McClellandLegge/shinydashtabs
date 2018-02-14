#' Find the existing tab names
#'
#' @param path Where to start the search
#'
#' @return A character vector
#' @export
#'
#' @examples
#' demo_app_ui <- system.file("extdata", "demo-app", "ui", package = "shinytabconstructor", mustWork = TRUE)
#' getExistingTabs(demo_app_ui)
getExistingTabs <- function(path = "ui/body/tabs") {

  # find the file paths of any R files under the tabs directory
  # look at the yamls only, unconfigured tabs aren't considered
  paths <- list.files(path, pattern = "\\.yaml$", full.names = TRUE, recursive = TRUE)

  # extract the names according to the conventions of the scaffold
  # assign the names so we know the location of each tab
  names(paths) <- shinytabconstructor::extractTabName(paths)

  return(paths)
}
