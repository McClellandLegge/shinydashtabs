
# create the UI by sourcing all the nested files below the ui/ directory,
# package functions handle the list of UI objects appropriately in the
# menu sidebar. use the server function that sources all serverside files
shinyApp(ui = includeR("ui"), server = function(input, output, session) {

   server_files <- list.files(
      path       = "./server/"
    , recursive  = TRUE
    , pattern    = "(*reactives.R|*observers.R|*renders.R)"
    , full.names = TRUE
  )

  for (file in server_files) {
    source(file, local = TRUE)$value
  }
})
