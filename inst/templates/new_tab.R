tab_name <- thisTabName()

tabItem(
  tabName = tab_name,
  fluidRow(
    column(width = 6,
      box(
        title       = sprintf("%s Controls", tools::toTitleCase(tab_name)),
        status      = "warning",
        width       = "100%",
        solidHeader = TRUE,
        actionButton(paste0(tab_name, "_button"), "Toggle")
      ) #/ box
    ), #/ column 1
    column(
      width = 6,
      box(
        title       = "Scatterplot",
        status      = "primary",
        width       = "100%",
        solidHeader = TRUE,
        plotOutput(paste0(tab_name, "_plot"))
      ) #/ box
    ) #/ column 2
  ) #/ fluidRow
) #/ tabItem

