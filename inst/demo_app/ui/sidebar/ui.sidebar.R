dashboardSidebar(
  sidebarMenu(
    .list = filesInTreeStructure("ui/body/tabs/", pattern = "\\.yaml$") %>%
      makeMenu()
  ) #/ sidebarMenu
) #/ dashboardSidebar

