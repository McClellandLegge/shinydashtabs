#' Create a new tab
#'
#' @param name A character string. What to call the tab? Cannot start with a number.
#' @param parent A character string. The name of the tab the new parent should go under. Defaults to 'ui'
#'     which indicates the tab should be accessible on the top level of the main menu
#' @param tabs A file path. The location of the top of the tabs in an app's ui directory
#' @param active A Boolean. Should the .yaml be initialized to immediately include the tab in the app?
#' @param open A Boolean. Should RStudio attempt to open the tab you just created?
#'
#' @export
addTab <- function(name, parent = 'ui', tabs = "ui/body/tabs", active = TRUE, open = TRUE) {

  # check the naming conventions against the default
  stopifnot(shinytabconstructor::checkNamingConventions(name))

  # check that there is no duplication of names
  stopifnot(shinytabconstructor::checkDuplicateTabNames(path = tabs, name))

  # find the parent directory
  if (parent == 'ui') {
    parent_dir <- tabs
  } else {
    parent_dir <- dirname(shinytabconstructor::findTab(parent, tabs))
    if (is.na(parent_dir)) {
      stop(paste("Tab", parent, "not found!"))
    }
  }

  # check that the directory doesn't exist already
  new_tab_dir <- file.path(parent_dir, name)
  if (dir.exists(new_tab_dir)) {
    stop(paste0(new_tab_dir, " exists already! Remove before continuing"))
  } else {
    stopifnot(dir.create(new_tab_dir))
  }

  # create the R and yaml files
  new_tab_fl <- file.path(new_tab_dir, name)
    copy_res <- file.copy(
    system.file("templates", "new_tab.R", package = "shinytabconstructor"),
    paste0(new_tab_fl, ".R")
  )

  # delete the directory if the copy isn't successful
  if (copy_res != TRUE) {
    unlink(new_tab_dir, recursive = TRUE, force = TRUE)
    stop("Copy not successful -- Failed!")
  }

  # initialize the yaml if the user wants it to appear right away
  if (active == TRUE) {
    stopifnot(file.create(paste0(new_tab_fl, ".yaml")))
  }

  # open the files in RStudio
  if (open == TRUE) {
    file.edit(paste0(new_tab_fl, ".", c("R", "yaml")))
  }
}
