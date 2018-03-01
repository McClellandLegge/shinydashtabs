#' Source R files to the .GlobalEnv
#'
#' @param dir A directory path
#'
#' @export
sourceR <- function(dir) {

  if (!dir.exists(dir)) {
    stop(paste(dir, "does not exist!"))
  }

  scripts <- list.files(
      path       = dir
    , recursive  = TRUE
    , pattern    = "\\.R$"
    , full.names = TRUE
  )

  for (script in scripts) {
    source(script, local = .GlobalEnv)
  }

  return(invisible(TRUE))
}
