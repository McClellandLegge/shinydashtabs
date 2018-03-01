#' Initialize the framework
#'
#' @export
#' @import purrr
initTabConstructor <- function() {

  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("`purrr` needed for this function to work. Please install it.", call. = FALSE)
  }

  if (!requireNamespace("utils", quietly = TRUE)) {
    stop("`utils` needed for this function to work. Please install it.", call. = FALSE)
  }

  app_dir <- rprojroot::find_rstudio_root_file()
  title   <- sprintf("Using:\n\n%s\n\nas the app's root directory, continue?", app_dir)
  resp    <- utils::menu(c("Yes", "No"), title = title)

  if (resp != 1L) {
    return(invisible(FALSE))
  }

  # check to make sure these files/directories don't exist
  check_files <- c("ui", "server", "init", "ui.R", "server.R", "app.R") %>% toupper()
  exist_files <- list.files(
      include.dirs = TRUE
    , no..         = TRUE
    , recursive    = FALSE
  )

  # identify the files that conflict
  conflict_files <- exist_files %>%
    toupper() %>%
    map_lgl(~. %in% check_files) %>%
    exist_files[.]

  # check that the user is ok with overwriting the files
  if (length(conflict_files) > 0L) {

    # compose the message for the user
    overwrite_msg <- paste0(conflict_files, collapse = "\n") %>%
      sprintf("Files/directories to be overwritten:\n\n%s\n\nContinue?", .)

    resp2  <- utils::menu(c("Yes", "No"), title = overwrite_msg)
    if (resp2 == 1L) {
      resp3  <- utils::menu(c("Yes", "No"), title = "Are you SURE?")
      if (resp3 != 1L) {
        return(invisible(FALSE))
      } #/ resp3 if-block
      # delete the existing files
      unlink(conflict_files, recursive = TRUE, force = TRUE)
    } else {
      return(invisible(FALSE))
    } #/ resp2 if-block
  } #/ length existing files if-block

  # execute the copy
  copy_res <- system.file("demo_app", package = "shinytabconstructor") %>%
    list.files(full.names = TRUE) %>%
    file.copy(., app_dir, recursive = TRUE)

  # initialize server dir if not already
  if (!dir.exists("server")) {
    dir.create("server")
  }

  writeLines("Done! Add tabs with the 'addTab' function.")
  return(invisible(TRUE))
}
