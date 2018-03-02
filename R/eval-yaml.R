#' Evaluate a YAML list
#'
#' @param yaml_list
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
