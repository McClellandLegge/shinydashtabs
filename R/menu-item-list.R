#' Create a menu item
#'
#' @param text Text to show for the menu item.
#' @param .list An optional list of \code{\link[shinydashboard]{menuSubItem}}s
#' @param icon An icon tag, created by \code{\link[shiny]{icon}}. If
#'   \code{NULL}, don't display an icon.
#' @param badgeLabel A label for an optional badge. Usually a number or a short
#'   word like "new".
#' @param badgeColor A color for the badge. Valid colors are listed in
#'   \link[shinydashboard]{validColors}.
#' @param href An link address. Not compatible with \code{tabName}.
#' @param tabName The name of a tab that this menu item will activate. Not
#'   compatible with \code{href}.
#' @param newtab If \code{href} is supplied, should the link open in a new
#'   browser tab?
#' @param selected If \code{TRUE}, this \code{menuItem} or \code{menuSubItem}
#'   will start selected. If no item have \code{selected=TRUE}, then the first
#'   \code{menuItem} will start selected.
#' @param expandedName A unique name given to each \code{menuItem} that serves
#'   to indicate which one (if any) is currently expanded. (This is only applicable
#'   to \code{menuItem}s that have children and it is mostly only useful for
#'   bookmarking state.)
#' @param startExpanded Should this \code{menuItem} be expanded on app startup?
#'   (This is only applicable to \code{menuItem}s that have children, and only
#'   one of these can be expanded at any given time).
#'
#' @details Exactly the same as \code{\link[shinydashboard]{menuItem}} except that
#'     the \code{\link[shinydashboard]{menuSubItem}}s can be passed in a list.
#'     All creational credit to the maintainers of that package
#' @export
menuItemList <- function(text, .list, icon = NULL, badgeLabel = NULL, badgeColor = "green",
                          tabName = NULL, href = NULL, newtab = TRUE, selected = NULL,
                          expandedName = as.character(gsub("[[:space:]]", "", text)),
                          startExpanded = FALSE)
{

  subItems <- .list

  if (!is.null(icon)) {
    shinydashboard:::tagAssert(icon, type = "i")
  }

  if (!is.null(href) + (!is.null(tabName) + (length(subItems) > 0) != 1)) {
    stop("Must have either href, tabName, or sub-items (contained in ...).")
  }

  if (!is.null(badgeLabel) && length(subItems) != 0) {
    stop("Can't have both badge and subItems")
  }

  shinydashboard:::validateColor(badgeColor)
  isTabItem <- FALSE
  target    <- NULL

  if (!is.null(tabName)) {
    shinydashboard:::validateTabName(tabName)
    isTabItem <- TRUE
    href      <- paste0("#shiny-tab-", tabName)
  } else if (is.null(href)) {
    href <- "#"
  } else {
    if (newtab) {
      target <- "_blank"
    }
  }

  if (!is.null(badgeLabel)) {
    badgeTag <- shiny::tags$small(class = paste0("badge pull-right bg-", badgeColor), badgeLabel)
  } else {
    badgeTag <- NULL
  }

  if (length(subItems) == 0) {
    c_li <- shiny::tags$li(
      shiny::a(
          href = href
        , `data-toggle` = if (isTabItem) "tab"
        , `data-value` = if (!is.null(tabName)) tabName
        , `data-start-selected` = if (isTRUE(selected)) 1 else NULL
        , target = target
        , icon
        , shiny::span(text)
        , badgeTag
      ) #/ a
    ) #/ li
    return(c_li)
  }
  default      <- if (startExpanded) expandedName else ""
  dataExpanded <- shinydashboard:::`%OR%`(shiny::restoreInput(id = "sidebarItemExpanded", default), "")
  isExpanded   <- nzchar(dataExpanded) && (dataExpanded == expandedName)
  shiny::tags$li(
      class = "treeview"
    , shiny::a(
        href = href
      , icon
      , shiny::span(text)
      , shiny::icon("angle-left", class = "pull-right")
    ) #/ a
    , do.call(
      shiny::tags$ul
      , c(
          class = paste0("treeview-menu", if (isExpanded) " menu-open" else "")
        , style = paste0("display: ", if (isExpanded) "block;" else "none;")
        , `data-expanded` = expandedName, subItems)
      ) #/ do.call
    ) #/ li
}
