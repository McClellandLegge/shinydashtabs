
#' Remove an existing tab
#'
#' @param name A character string. What to call the tab? Cannot start with a number.
#' @param cascade A boolean, should it delete all tabs below it?
#'
#' @export
deleteTab <- function(name, cascade = FALSE) {

  # find the file path of the location of the tabs
  ser_loc <- shinytabconstructor::getServerLocation()
  tab_dir <- dirname(shinytabconstructor::findTab(name))
  tab_fls <- paste0(name, ".", c("R", "yaml"))
  ser_dir <- file.path(ser_loc, name)
  ser_fls <- paste(name, c("renders.R", "reactives.R", "observers.R"), sep = "_")

  # check the existance of the tab dirs
  if (!dir.exists(tab_dir)) {
    stop("UI folder doesn't exist")
  }

  # check the existance of the server dirs
  if (!dir.exists(ser_dir)) {
    stop("Server dir doesn't exist")
  }

  # see if any tabs are under the tab to be deleted
  child_tab_names <- shinytabconstructor::getChildTabs(name)
  has_children    <- length(child_tab_names) > 0L
  if (has_children == TRUE) {
    child_tab_str   <- paste0(child_tab_names, collapse = ", ")
    msg             <- sprintf("The %s tab has children: %s", name, child_tab_str)
    ques            <- sprintf("\n\nAre you sure you want to delete tab '%s'?", name)
    resp            <- utils::menu(c("Yes", "No"), title = paste0(msg, ques))
    if (resp != 1L) {
      return(invisible(FALSE))
    }
  } else {
    title <- sprintf("Are you sure you want to delete tab '%s'?", name)
    resp  <- utils::menu(c("Yes", "No"), title = title)
    if (resp != 1L) {
      return(invisible(FALSE))
    }
  }

  # find the tab UI directory
  tab_dir_fls <- list.files(
      path         = tab_dir
    , all.files    = TRUE
    , include.dirs = TRUE
    , full.names   = TRUE
    , no..         = TRUE
  )

  # find any files that aren't standard
  if (has_children == TRUE) {
    ignore         <- c(tab_fls, child_tab_names)
    child_ser_dirs <- file.path(ser_loc, child_tab_names)
  } else {
    ignore <- tab_fls
  }
  non_tab_fls <- grep(
      pattern  = paste0(ignore, collapse = "|")
    , x        = basename(tab_dir_fls)
    , invert   = TRUE
  )

  # find the server directory
  ser_dir_fls <- list.files(
      path         = ser_dir
    , all.files    = TRUE
    , include.dirs = TRUE
    , full.names   = TRUE
    , no..         = TRUE
  )

  # find any files that aren't standard
  non_ser_fls <- grep(
      pattern  = paste0(ser_fls, collapse = "|")
    , x        = basename(ser_dir_fls)
    , invert   = TRUE
  )

  # don't delete directory if other files are present
  if (cascade == FALSE) {

    msgs <- list()
    if (length(non_tab_fls) > 0L) {
      fl_msg  <- paste0(tab_dir_fls[non_tab_fls], collapse = "\n")
      msgs[['tab']] <- sprintf("Found non-standard files in UI folder:\n\n%s\n\n", fl_msg)
    } #/ non-tab files if-block

    if (length(non_ser_fls) > 0L) {
      fl_msg  <- paste0(ser_dir_fls[non_ser_fls], collapse = "\n")
      msgs[['server']] <- sprintf("Found non-standard files in server folder:\n\n%s\n\n", fl_msg)
    } #/ non-ser files if block

    if (length(child_tab_names) > 0L) {
      fl_msg  <- paste0(child_tab_names, collapse = "\n")
      msgs[['server']] <- sprintf("Child tab(s) found:\n\n%s\n\n", fl_msg)
    }

    if (length(msgs) > 0L) {
      msg <- paste0("'cascade' set to FALSE but:\n\n", do.call(paste0, msgs))
      stop(msg)
    } #/ msg length if-block

  } #/ cascade if-block

  # delete folders
  .unlink(tab_dir, TRUE, TRUE)
  .unlink(ser_dir, TRUE, TRUE)

  # delete sever side code for children
  if (length(child_ser_dirs) > 0L) {
    for (child_dir in child_ser_dirs) {
      .unlink(child_dir, TRUE, TRUE)
    }
  }

  return(invisible(TRUE))
}
