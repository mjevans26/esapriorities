#'Launch Shiny App to explore workplan data.
#'
#'@example
#'runExample()
#'@export
runExample <- function() {
  appDir <- system.file("shiny-examples", "plan_explorer", package = "esapriorities")
  if (appDir == "") {
    stop("Could not find example directory. Try re-installing 'mypackage'.", call. = FALSE)
  }
  shiny::runAPP(appDir, display.mode = "normal")
}