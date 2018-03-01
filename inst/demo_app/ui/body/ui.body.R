dashboardBody(
  useShinyjs(), # enable shinyJS
  includeScript("www/js/display-loading-gif.js"), # load custom javascript
  includeCSS("www/css/loading-image.css"), # load custom CSS
  tabItemList(
    # each tab is an R file in this director
    includeR(file.path("ui", "body", "tabs"), recursive = TRUE)
  ) #/ tabItemList
) #/ dashboardBody
