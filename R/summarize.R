#' Count number of unique value occurrences within categorical subsets.
#' 
#' @param dat A data frame
#' @param x name of column to be counted as character string
#' @param y name of column defining categories
#' @return named list of counts of unique values of \code{x} within subsets defined by \code{y}
#' @examples
#'summarize(data2, "Species", "Year")
summarize <- function(dat, x, y) {
  with(dat, tapply(get(x), get(y), function(x) length(unique(x)), simplify = TRUE))
}


#' Identify species based on priority and timeline criteria.
#' 
#' @param dat A data frame
#' @param x Numeric value of priority level
#' @param y Numeric indicating fiscal year
#' @param crit String indicating "LPN" or "Priority"
#' @return data frame subset of \code{dat}
#' @examples
#' identify(data, 8, 2020, "LPN")
identify <- function(dat, x, y, crit) { 
  if (crit == "Priority") {
    dat[which(dat$Priority == x & dat$Timeframe == paste0("FY",substr(y, 3, 4))), ]
  } else if (crit == "LPN") {
    dat[which(dat$LPN == x & dat$Timeframe == paste0("FY",substr(y, 3, 4))), ]
  }
}

