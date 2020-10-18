#' Check the files against naming conventions
#'
#' @param tocheck An optional character vector of names to check against the existing ones
#'
#' @export
#' @import purrr
checkDuplicateTabNames <- function(tocheck = NULL) {

  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("`purrr` needed for this function to work. Please install it.", call. = FALSE)
  }

  # find the file paths of any R files under the tabs directory
  paths     <- shinydashtab::getExistingTabs()
  tab_names <- names(paths)

  # determine if any are duplicated by seeing which indices match each entry
  # (marked by a 1, nomatch by a 0), if there is more than a single 1 its duped,
  # but we get to keep the indices of the ones it matched for specific
  # reporting of the offenders
  matches <- map(tab_names, ~match(tab_names, ., nomatch = 0L)) %>%
    map(~which(. == 1L))

  # keep only the ones that have a length greater than one, unique because
  # each duplication is reported by each offender
  dupes <- keep(matches, ~length(.) > 1L) %>% unique()
  if (length(dupes) > 0L) {
    msgs <- map(dupes, function(dupe_ixs) {
      # find the actual name that's being duplicated
      tab_name  <- unique(tab_names[dupe_ixs])

      # find the names of the files that are being duplicated
      offenders <- paths[dupe_ixs]

      # print the files under the duplicated tab name
      sprintf("\n'%s':\n%s\n", tab_name, paste0(offenders, collapse = "\n"))
    }) %>%
      # paste all together
      reduce(paste0)

    msg <- paste0("These tab files have duplicated tab names -- please rename!\n", msgs)

    stop(msg)
  } #/ dupes block

  if (!is.null(tocheck) && is.character(tocheck)) {

    dupe_ix  <- match(tocheck, tab_names)
    check_ix <- which(!is.na(dupe_ix))

    if (length(check_ix) > 0L) {
      msgs <- map(check_ix, function(ix) {
        sprintf("\n'%s':\n%s\n", tocheck[ix], paths[dupe_ix[ix]])
      }) %>%
        reduce(paste0)

      msg <- paste0("These 'tocheck' names would be duplicates -- please don't use!\n", msgs)

      stop(msg)
    } else {
      return(TRUE)
    } #/ dupe 'tocheck' block

  } else {
    return(TRUE)
  } #/ 'tocheck' block

}
