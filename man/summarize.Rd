% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summarize.R
\name{summarize}
\alias{summarize}
\title{Count number of unique value occurrences within categorical subsets.}
\usage{
summarize(dat, x, y)
}
\arguments{
\item{dat}{A data frame}

\item{x}{name of column to be counted as character string}

\item{y}{name of column defining categories}
}
\value{
named list of counts of unique values of \code{x} within subsets defined by \code{y}
}
\description{
Count number of unique value occurrences within categorical subsets.
}
\examples{
summarize(data2, "Species", "Year")
}

