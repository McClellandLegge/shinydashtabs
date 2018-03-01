
# the basic libraries needed to run the app
# put all additional library loads in the init/01_libraries.R file
library("shiny")
library("shinydashboard")
library("shinytabconstructor")

# run the initialization scripts to define everything that need only be
# run once, or needs to be available in both server and ui side code
sourceR("init")

# create the UI by sourcing all the nested files below the ui/ directory,
# package functions handle the list of UI objects appropriately in the
# menu sidebar. use the server function that sources all serverside files
shinyApp(ui = includeR("ui"), server = serverFunc)
