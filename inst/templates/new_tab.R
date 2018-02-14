tab_name <- thisTabName()

tabItem(
  tabName = tab_name,
  h2(tab_name),
  actionButton(paste0(tab_name, "_button"), "Toggle"),
  plotOutput(paste0(tab_name, "_plot"))
) #/ tabItem

