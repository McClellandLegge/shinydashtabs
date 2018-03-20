#' Source the server functions
#'
#' @export
#' @import data.table
serverFunc <- function(input, output, session) {
  server_files <- list.files(
      path       = "./server/"
    , recursive  = TRUE
    , pattern    = "(*reactives.R|*observers.R|*renders.R)"
    , full.names = TRUE
  )

  for (file in server_files) {
    source(file, local = TRUE)$value
  }
}
