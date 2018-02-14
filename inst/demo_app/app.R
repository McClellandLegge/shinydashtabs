
library("shiny")
library("purrr")
library("shinyjs")
library("ggplot2")
library("shinydashboard")
library("shinytabconstructor")

# create the UI by sourcing all the nested files below the ui/ directory,
# package functions handle the list of UI objects appropriately in the
# menu sidebar. use the server function that sources all serverside files
shinyApp(ui = includeR("ui"), server = serverFunc)
