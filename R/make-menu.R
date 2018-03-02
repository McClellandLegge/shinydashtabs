#' Make a menu from a configured hierarchical list
#'
#' @param .list A (possibly) nested list of the .yaml files defining a menu structure
#'
#' @return A list of html menu objects
#' @export
#' @import purrr
makeMenu <- function(.list) {

  if (!requireNamespace("yaml", quietly = TRUE)) {
    stop("`yaml` needed for this function to work. Please install it.", call. = FALSE)
  }

  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("`purrr` needed for this function to work. Please install it.", call. = FALSE)
  }

  if (!requireNamespace("tools", quietly = TRUE)) {
    stop("`tools` needed for this function to work. Please install it.", call. = FALSE)
  }

  if (!requireNamespace("shinydashboard", quietly = TRUE)) {
    stop("`shinydashboard` needed for this function to work. Please install it.", call. = FALSE)
  }

  # if there are any yamls in the top level of the list -- discard them
  clist            <- discard(.list, grepl("\\.yaml$", names(.list)))

  # the raw names of the top level list
  menu_names       <- names(clist)

  # make some prettier labels by converting them to title case
  menu_labels      <- tools::toTitleCase(gsub("_", " ", menu_names))

  # strip out the child names for each list item
  menu_child_names <- map(clist, ~names(.))

  # create a storage list
  l                <- list()
  for (k in seq_along(clist)) {

    # read in the options, discard any null values
    yaml_opts <- yaml::read_yaml(clist[[k]][[1]]) %>%
      discard(is.null) %>%
      evaluateYAML()

    # we ignore a tabName if specified as this is automatically handled by
    # the package framework
    yaml_opts[['tabName']] <- menu_names[k]

    # coalesce with the defaults
    yaml_opts[['text']] <- coalesce(yaml_opts[['text']], menu_labels[k])

    # look at the position in the hierarchy
    has_only_yaml_children <- grepl("\\.yaml$", menu_child_names[[k]])
    is_top_level           <- attr(clist[[k]], "top-level")

    if (is.null(is_top_level) || !is.logical(is_top_level)) {
      is_top_level <- FALSE
    }

    if (all(has_only_yaml_children)) {
      if (is_top_level == TRUE) {
        l[[k]] <- do.call(shinydashboard::menuItem, args = yaml_opts)
      } else {
        # if the list item only has yamls below it we know that we can supply
        # a menu list sub item
        l[[k]] <- do.call(shinydashboard::menuSubItem, args = yaml_opts)
      } #/ is top level if-block
    } else {
      # if we see non-yaml names below (i.e. what we assume to be more directories)
      # we want to initialize a menu item and create either more menu items or
      # sub menu items recursively.
      yaml_opts[[".list"]] <- shinytabconstructor::makeMenu(clist[[k]])
      l[[k]] <- do.call(shinytabconstructor::menuItemList, args = yaml_opts)
    } #/ if-else block
  } #/ seqlong clist block

  return(l)
}
