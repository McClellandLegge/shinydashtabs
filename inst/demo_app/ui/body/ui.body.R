dashboardBody(
  useShinyjs(), # enable shinyJS
  tabItemList(
    # each tab is an R file in this director
    includeR(file.path("ui", "body", "tabs"), recursive = TRUE)
  ) #/ tabItemList
) #/ dashboardBody
