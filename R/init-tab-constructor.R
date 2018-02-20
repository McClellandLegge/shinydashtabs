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
  resp1   <- utils::menu(c("Yes", "No"), title = title)

  if (resp1 == 1L) {
    # we use a while block so that we can `break` and return to the top level
    # anywhere without having to call a `stop`
    while (TRUE) {
      check_names <- c("ui", "server", "app")

      # check all capitalizations
      existing_files <- list.files(
        pattern      = paste0(check_names, collapse = "|") # make "OR" condition
        , ignore.case  = TRUE
        , full.names   = TRUE
        , recursive    = FALSE
        , include.dirs = TRUE
      )

      # compose the message for the user
      overwrite_msg <- paste0(existing_files, collapse = "\n") %>%
        sprintf("Files/directories to be overwritten:\n\n%s\n\nContinue?", .)

      # check that the user is ok with overwriting the files
      if (length(existing_files) > 0L) {
        resp2  <- utils::menu(c("Yes", "No"), title = overwrite_msg)
        if (resp2 == 1L) {
          resp3  <- utils::menu(c("Yes", "No"), title = "Are you SURE?")
          if (resp3 != 1L) {
            break()
          } #/ resp3 if-block
          # delete the existing files
          unlink(existing_files, recursive = TRUE, force = TRUE)
        } else {
          break()
        } #/ resp2 if-block
      } #/ length existing files if-block

      # execute the copy
      copy_res <- system.file("demo_app", package = "shinytabconstructor") %>%
        list.files(full.names = TRUE) %>%
        file.copy(., app_dir, recursive = TRUE)

      writeLines("Done! Add tabs with the 'addTab' function.")
      break()

    } #/ dummy while block
  } #/ resp1 if-block
}
