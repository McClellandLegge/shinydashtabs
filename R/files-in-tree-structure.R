#' Determine a directory file structure
#'
#' @param file The root directory or file
#' @param pattern An optional pattern to filter out directories containing files
#'
#' @return A list
#' @export
filesInTreeStructure <- function(file, pattern = NULL) {
  isdir <- file.info(file)$isdir
  if (isdir == FALSE) {
    out <- file
    if (!is.null(pattern)) {
      if (!grepl(pattern, out)) {
        return(NULL)
      }
    }
  } else {
    files      <- list.files(file, full.names = TRUE, include.dirs = TRUE)
    out        <- lapply(files, shinydashtabs::filesInTreeStructure, pattern = pattern)
    names(out) <- basename(files)
  }

  non_null <- Filter(Negate(is.null), out)

  if (length(non_null) == 0L) {
    return(NULL)
  } else {
    return(non_null)
  }
}
