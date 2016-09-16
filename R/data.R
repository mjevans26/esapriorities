#' FWS data on 7yr ESA implementation plan
#'
#'The US Fish and Wildlife Service (FWS) provides a seven year plan 
#'oulining prioritization of pending ESA status reviews, the process the
#'agency uses to determine whether a species requires federal protection.  
#'The workplan documents all species with pending status reviews, and
#'provides information about each species' review timeline and prioritization. 
#'
#'@format A data frame with 363 rows and 10 variables
#'\describe{
#'\item{\code{Package.Name}}{Species grouping}
#'\item{\code{Species.name}}{Name of species; common or scientific}
#'\item{\code{Action.Type}}{Type of action}
#'\item{\code{Lead.RO}}{Primary FWS regional office responsible for species assessment}
#'\item{\code{Priority.Bin.Ranking}}{Listing Priority Number (LPN) or priority bin}
#'\item{\code{Timeframe}}{Fiscal Year for status review}
#'\item{\code{Current.Candidate}}{Current candidate for listing?}
#'\item{\code{Range}}{List of states and territories in which species is found}
#'\item{\code{LPN}}{Listing Priority Number; 1 - 12}
#'\item{\code{Priority}}{Status review priority bin; 1-5}
#'}
#'
#'
#'
#'@source \url{https://www.fws.gov/endangered/esa-library}
"data"

#' FWS data on 7yr ESA implementation plan 
#'
#'Data identical to \code{data}, with unnested lists of states for each species. 
#'Each record represents a single species by state combination.
#'
#'@format A data frame with 1120 rows and 12 variables
#'\describe{
#'\item{\code{Package.Name}}{Species grouping}
#'\item{\code{Species.name}}{Name of species, either common or scientific}
#'\item{\code{Action.Type}}{Type of action}
#'\item{\code{Lead.RO}}{Primary FWS regional office responsible for species assessment}
#'\item{\code{Priority.Bin.Ranking}}{}
#'\item{\code{Timeframe}}{Fiscal Year for status review}
#'\item{\code{Current.Candidate}}{Current candidate for listing?}
#'\item{\code{Range}}{List of states and territories in which species is found}
#'\item{\code{LPN}}{Listing Priority Number; 1 - 12}
#'\item{\code{Priority}}{Status review priority bin; 1-5}
#'\item{\code{State}}{Individual states in which species is found}
#'\item{\code{OriginRow}}{Row number of species record in \code{data}}
#'}
#'
#'@source \url{https://www.fws.gov/endangered/esa-library}
"data_states"