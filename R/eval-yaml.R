#' Evaluate a YAML list in place
#'
#' @param yaml_list A possibly nested list of objects read from a YAML file
#'
#' @return A list
#' @export
evaluateYAML <- function(yaml_list) {
  handler <- function(x) {
    if (inherits(x, "character")) {
      return(eval(parse(text = x)))
    } else {
      return(x)
    }
  }
  rapply(yaml_list, handler, how = "list")
}
