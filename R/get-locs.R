#' Find the physical location of the tabs within the project
#'
#' @return A character string: The fully qualified file path to the tabs folder
#' @export
getTabLocation <- function() {
  tab_loc <- file.path(rprojroot::find_rstudio_root_file(), 'ui', 'body', 'tabs')

  if (!dir.exists(tab_loc)) {
    msg <- sprintf("Expecting the tabs in:\n\n%s\n\nAre you sure this is a tab constructor project?", tab_loc)
    stop(msg, call. = FALSE)
  }

  return(tab_loc)
}


#' Find the physical location of the server file within project
#'
#' @return A character string: The fully qualified file path to the server folder
#' @export
getServerLocation <- function() {
  server_loc <- file.path(rprojroot::find_rstudio_root_file(), 'server')

  if (!dir.exists(server_loc)) {
    msg <- sprintf("Expecting the server code in:\n\n%s\n\nAre you sure this is a tab constructor project?", server_loc)
    stop(msg, call. = FALSE)
  }

  return(server_loc)
}
