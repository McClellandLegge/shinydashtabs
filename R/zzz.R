.unlink <- function(x, recursive = FALSE, force = FALSE) {
  if (unlink(x, recursive, force) == 0)
    return(invisible(TRUE))
  stop(sprintf("Failed to remove [%s]", x))
}
