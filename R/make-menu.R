#' Make a menu from a configured hierarchical list
#'
#' @param .list A (possibly) nested list of the .yaml files defining a menu structure
#'
#' @return A list of html menu objects
#' @export
makeMenu <- function(.list) {

  . <- NULL # make R check happy

  # if there are any yamls in the top level of the list -- discard them
  clist            <- discard(.list, grepl("\\.yaml$", names(.list)))

  # the raw names of the top level list
  menu_names       <- names(clist)

  # make some prettier labels by converting them to title case
  menu_labels      <- tools::toTitleCase(gsub("_", " ", menu_names))

  # strip out the child names for each list item
  menu_child_names <- purrr::map(clist, ~names(.))

  # create a storage list
  l                <- list()
  position         <- integer(length(clist))
  for (k in seq_along(clist)) {

    # read in the options, discard any null values
    yaml_opts <- menu_names[k] %>%
      sprintf("%s.yaml", .) %>%
      clist[[k]][[.]] %>%
      yaml::read_yaml() %>%
      discard(is.null) %>%
      evaluateYAML()

    # we ignore a tabName if specified as this is automatically handled by
    # the package framework
    yaml_opts[['tabName']] <- menu_names[k]

    # coalesce with the defaults
    yaml_opts[['text']] <- coalesce(yaml_opts[['text']], menu_labels[k])

    # is a position specified?
    pos <- yaml_opts[['position']]
    if (is.integer(pos)) {
      position[k] <- pos
    } else {
      if (!is.null(pos))  {
        warning(sprintf("'position' option in '%s' yaml is not an integer, ignoring...", menu_names[k]))
      }
      position[k] <- NA
    }

    # delete the position option so its not passed to the function call below
    yaml_opts[['position']] <- NULL

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
      yaml_opts[[".list"]] <- shinydashtabs::makeMenu(clist[[k]])
      l[[k]] <- do.call(shinydashtabs::menuItemList, args = yaml_opts)
    } #/ if-else block
  } #/ seqlong clist block

  # return the list with position ordering. if none are specified the order
  # will be the same as is read
  return(l[order(position)])
}
