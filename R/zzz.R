.unlink <- function(x, recursive = FALSE, force = FALSE) {
  if (unlink(x, recursive, force) == 0)
    return(invisible(TRUE))
  stop(sprintf("Failed to remove [%s]", x))
}


coalesce <- function(...) {
  Reduce(function(x, y) {
    i <- which(is.null(x) || is.na(x))
    x[i] <- y[i]
    x},
    list(...))
}
