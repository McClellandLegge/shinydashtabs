#' Check the naming conventions of the app files
#'
#' @param criteria A regex expression to definite the allowable characters
#'
#' @export
checkFileNamingConventions <- function(criteria = "[^a-z0-9_\\.\\/]") {

  # check the files for invalid names
  r_files <- list.files(recursive = TRUE, pattern = "\\.R$") %>%
    map_chr(tools::file_path_sans_ext)
  bad_r_files <- r_files[grepl(criteria, r_files)]

  msg <- list()
  if (length(bad_r_files) > 0) {
    fls_msg <- paste("The following files don't meet the criteria:", criteria)
    bad_str <- paste0(bad_r_files, collapse = "\n")
    msg[["files"]] <- paste0(fls_msg, "\n", bad_str, "\n\n")
  }

  # check the directories for invalid names
  r_dirs <- list.dirs()
  bad_r_dirs <- r_dirs[grepl(criteria, r_dirs)]

  if (length(bad_r_dirs) > 0) {
    dir_msg <- paste("The following directories don't meet the criteria:", criteria)
    bad_str <- paste0(bad_r_dirs, collapse = "\n")
    msg[["dirs"]] <- paste0(dir_msg, "\n", bad_str)
  }

  # if there are any bad ones, concat and stop
  if (length(msg) > 0) {
    stop(msg)
  } else {
    return(TRUE)
  }
}
