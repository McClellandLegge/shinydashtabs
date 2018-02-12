#' Form a tab structure from one or more tab items
#'
#' @param items One or more \code{\link[shinydashboard]{tabItem}} in a list
#'
#' @return A html div
#' @export
tabItemList <- function (items) {

  if (!requireNamespace("shiny", quietly = TRUE)) {
    stop("`shiny` needed for this function to work. Please install it.", call. = FALSE)
  }

  shiny::div(class = "tab-content", items)
}
