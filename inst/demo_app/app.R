
# create the UI by sourcing all the nested files below the ui/ directory,
# package functions handle the list of UI objects appropriately in the
# menu sidebar. use the server function that sources all server side files
shiny::shinyApp(ui = includeR("ui"), server = function(input, output, session) {

   server_files <- fs::dir_ls(
      path       = "./server/"
    , recurse    = TRUE
    , regexp     = "(*reactives.R|*observers.R|*renders.R)"
    , type       = "file"
  )

  for (file in server_files) {
    source(file, local = TRUE)$value
  }
})
