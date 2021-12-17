#' Launch Shiny App to explore workplan data.
#' 
#' @export
#' @examples
#' runExample()
runExample <- function() {
  appDir <- system.file("listing-workplan", package = "esapriorities")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing 'esapriorities'.", call. = FALSE)
  }
  shiny::runApp(appDir, display.mode = "normal")
}

