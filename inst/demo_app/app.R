
library("shiny")
library("purrr")
library("shinydashboard")
library("shinytabconstructor")

# create the UI by sourcing all the nested files below the ui/ directory,
# package functions handle the list of UI objects appropriately in the
# menu sidebar
ui     <- includeR("ui")

# create the server function by sourcing all the scripts below the server/
# directory which are then returned as a list, NULLs (empty scripts) are then
# tossed and the rest evaluated to be passed to the top level function
server <- function(input, output, session) {

  includeR("server", recursive = TRUE) %>%
    Filter(Negate(is.null), .) %>%
    do.call(eval, .)

} #/ serverFunction

# finally, run the app
shinyApp(ui = ui, server = server)

