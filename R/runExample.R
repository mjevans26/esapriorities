#' Launch Shiny App to explore workplan data.
#' 
#' @export
#' @examples
#' runExample()
runExample <- function() {
  appDir <- system.file("shiny-examples", package = "esapriorities")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing 'mypackage'.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}

