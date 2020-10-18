#' Add a server-side only module
#'
#' @param name Name of the server side module
#'
#' @return An invisible `TRUE` if successful
#' @export
addServerModule <- function(name) {

  pkg <- "shinydashtabs"

  # create the server side folder
  server_dir <- file.path(shinydashtabs::getServerLocation(), name)
  if (file.exists(server_dir)) {
    msg <- paste(server_dir, "already exists! Please remove it before continuing")
    stop(msg)
  }
  stopifnot(dir.create(server_dir))

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

    invisible(TRUE)
  }, error = function(e) stop(e))
}
