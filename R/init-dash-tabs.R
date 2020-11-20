#' Initialize the framework
#'
#' @export
initDashTabs <- function() {

  . <- NULL # make R check happy

  proj_dir <- rprojroot::find_rstudio_root_file()

  golem_initd <- fs::path(proj_dir, "inst/golem-config.yml") %>%
    fs::file_exists()

  if (!golem_initd) {
    cli::cli_alert_danger("No golem detected, you need to initialize a golem before initializing Dash Tabs. Initialize with:")
    cli::cli_verbatim(lines = "golem::create_golem(path = \".\")")
    return(invisible(FALSE))
  }

  app_dir <- fs::path(proj_dir, "inst/app")

  resp <- sprintf("Using:\n\n%s\n\nas the app's root directory, continue?", app_dir) %>%
    utils::menu(c("Yes", "No"), title = .)

  if (resp != 1L) {
    return(invisible(FALSE))
  }

  # check to make sure these files/directories don't exist
  check_files <- c("ui", "server", "ui.R", "server.R", "app.R") %>% toupper()
  exist_files <- fs::dir_ls(path = app_dir, all = FALSE)

  # identify the files that conflict
  conflict_files <- exist_files %>%
    purrr::keep(~toupper(.) %in% check_files)

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
      fs::file_delete(path = conflict_files, )
    } else {
      return(invisible(FALSE))
    } #/ resp2 if-block
  } #/ length existing files if-block

  # execute the copy
  cli::cli_alert_info("Populating inst/app/")
  template_dir <- system.file("demo_app", package = "shinydashtabs")

  fs::dir_copy(path = fs::path(template_dir, , new_path = app_dir, overwrite = TRUE))

    fs::dir_ls() %T>%
    purrr::walk(~{
      glue::glue("Copying {fn}", fn = basename(.)) %>% cli::cli_alert_success()
      if (fs::is_dir(.)) {

      } else {
        fs::file_copy(path = ., new_path = app_dir, overwrite = TRUE)
      }
    })

  # initialize server dir if not already
  cli::cli_alert_success("Creating inst/app/server/")
  server_dir <- fs::path(app_dir, "server")
  if (!fs::dir_exists(server_dir)) {
    fs::dir_create(server_dir, recurse = TRUE)
  }

  cli::cli_alert_success("Writing inst/dashtab-config.yml")
  tab_config_fl <- fs::path(proj_dir, "inst", "dashtab-config.yml")
  tab_config    <- list(app_dir = "inst/app")
  yaml::write_yaml(x = tab_config, file = tab_config_fl)

  cli::cli_alert_info("Done!")
  cli::cli_alert_info("Add tabs with the 'addTab' function")
  return(invisible(TRUE))
}
