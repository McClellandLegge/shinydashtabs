#' Create a new tab
#'
#' @param name A character string. What to call the tab? Cannot start with a number.
#' @param parent A character string. The name of the tab the new parent should go under. Defaults to 'ui'
#'     which indicates the tab should be accessible on the top level of the main menu
#' @param active A Boolean. Should the .yaml be initialized to immediately include the tab in the app?
#' @param open A Boolean. Should RStudio attempt to open the tab you just created?
#'
#' @export
addTab <- function(name, parent = 'ui', active = TRUE, open = TRUE) {

  # check the naming conventions against the default
  stopifnot(shinytabconstructor::checkNamingConventions(name))

  # check that there is no duplication of names
  stopifnot(shinytabconstructor::checkDuplicateTabNames(name))

  # just because its used so much
  pkg <- "shinytabconstructor"

  # find the file path of the location of the tabs
  tabs <- shinytabconstructor::getTabLocation()

  # find the parent directory
  if (parent == 'ui') {
    parent_dir <- tabs
  } else {
    parent_dir <- dirname(shinytabconstructor::findTab(parent))
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

  # create the server side folder
  server_dir <- file.path(shinytabconstructor::getServerLocation(), name)
  if (file.exists(server_dir)) {
    msg <- paste(server_dir, "already exists! Please remove it before continuing")
    stop(msg)
  }
  stopifnot(dir.create(server_dir))

  # create the R file
  new_tab_fl <- file.path(new_tab_dir, name)
  ui_copy_res <- file.copy(
    system.file("templates", "new_tab.R", package = pkg),
    paste0(new_tab_fl, ".R")
  )

  # delete the directory if the copy isn't successful
  if (ui_copy_res != TRUE) {
    unlink(new_tab_dir, recursive = TRUE, force = TRUE)
    stop("Copy not successful -- Failed!")
  }

  tryCatch({

    # find the templates from the package's installed files
    template_renders   <- system.file("templates", "new_server_renders.R", package = pkg)
    template_observers <- system.file("templates", "new_server_observers.R", package = pkg)
    template_reactives <- system.file("templates", "new_server_reactives.R", package = pkg)

    # compose the file paths for the output of the brews
    new_renders   <- file.path(server_dir, paste0(name, "_renders.R"))
    new_observers <- file.path(server_dir, paste0(name, "_observers.R"))
    new_reactives <- file.path(server_dir, paste0(name, "_reactives.R"))

    # use the 'name' value to replace the value in all of the templates, output
    # to the new location
    brew::brew(template_renders, new_renders)
    brew::brew(template_observers, new_observers)
    brew::brew(template_reactives, new_reactives)

  }, error = function(e) stop(e))

  # initialize the yaml if the user wants it to appear right away
  if (active == TRUE) {
    yaml_template <- system.file("templates", "menu_subitem.yaml", package = pkg)
    new_yaml      <- paste0(new_tab_fl, ".yaml")
    stopifnot(file.copy(yaml_template, new_yaml))
  }

  # open the files in RStudio
  if (open == TRUE) {
    new_ui_files   <- paste0(new_tab_fl, ".", c("R", "yaml"))
    new_serv_files <- c(new_renders, new_observers, new_reactives)
    file.edit(c(new_ui_files, new_serv_files))
  }
}
