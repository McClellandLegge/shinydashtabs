#' Form a tab structure from one or more tab items
#'
#' @param items One or more \code{\link[shinydashboard]{tabItem}} in a list
#'
#' @return A html div
#' @export
tabItemList <- function(items) {
  shiny::div(class = "tab-content", items)
}
