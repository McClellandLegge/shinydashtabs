#' Check the files against naming conventions
#'
#' @param path Root path
#'
#' @export
#' @import purrr
checkDuplicateTabNames <- function(path = "ui/body/tabs/") {

  if (!requireNamespace("purrr", quietly = TRUE)) {
    stop("`purrr` needed for this function to work. Please install it.", call. = FALSE)
  }

    # find the file paths of any R files under the tabs directory
  # implicitly ignores hidden files
  paths <- list.files(path, pattern = ".R$", full.names = TRUE, recursive = TRUE)

  # extract the names according to the conventions of the scaffold
  tab_names <- shinytabconstructor::extractTabName(paths)

  # determine if any are duplicated by seeing which indices match each entry
  # (marked by a 1, nomatch by a 0), if there is more than a single 1 its duped,
  # but we get to keep the indices of the ones it matched for specific
  # reporting of the offenders
  matches <- map(tab_names, ~pmatch(tab_names, ., duplicates.ok = TRUE, nomatch = 0L)) %>%
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

    msg <- paste0("These tab files have duplicated names -- please rename!\n", msgs)

    stop(msg)
  }

  return(TRUE)
}
