ui_tab_path <- file.path("ui", "body", "tabs")
ui_files    <- filesInTreeStructure(ui_tab_path, pattern = "\\.yaml$")

# assign the 'top-level' attribute to handle menu type assignment correctly
for(k in seq_along(ui_files)) {
  attr(ui_files[[k]], "top-level") <- TRUE
}

dashboardSidebar(
  sidebarMenu(
    .list = makeMenu(ui_files)
  ) #/ sidebarMenu
) #/ dashboardSidebar
