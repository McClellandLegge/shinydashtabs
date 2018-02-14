dashboardBody(
  tabItemList(
    # each tab is an R file in this director
    includeR("ui/body/tabs", recursive = TRUE)
  ) #/ tabItemList
) #/ dashboardBody
