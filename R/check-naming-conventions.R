#' Check the naming conventions of the app files
#'
#' @param files A character vector of file names
#' @param criteria A regex expression to definite the allowable characters
#'
#' @return \code{TRUE}
#' @examples
#' possible_names <- c("01-desc.R", "a.good.name.R", "another_acceptable.name.R")
#' try(checkNamingConventions(possible_names))
#' @export
#' @import purrr
checkNamingConventions <- function(files, criteria = "[^a-z0-9_\\.\\/]") {

  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("`purrr` needed for this function to work. Please install it.", call. = FALSE)
  }

  # check the files for invalid names
  files_ <- map_chr(files, basename) %>%
    map_chr(tools::file_path_sans_ext)

  # check criteria and that it doesn't start with anything else than a letter
  bad_files <- files_[grepl(criteria, files_) | grepl("^[^a-zA-Z]", files_)]

  if (length(bad_files) > 0) {
    fls_msg <- paste("The following files don't meet the criteria:", criteria)
    bad_str <- paste0(bad_files, collapse = "\n    ")
    stop(paste0(fls_msg, "\n    ", bad_str, "\n"))
  }

  return(TRUE)
}
