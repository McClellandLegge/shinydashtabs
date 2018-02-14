
library("shiny")
library("magrittr")
library("shinydashboard")
library("shinytabconstructor")

ui     <- includeR("ui")

server <- function(input, output, session) { 
  
  includeR("server", recursive = TRUE) %>%
    Filter(Negate(is.null), .) %>%
    do.call(eval, .)
    
  
} #/ serverFunction

shinyApp(ui = ui, server = server)

