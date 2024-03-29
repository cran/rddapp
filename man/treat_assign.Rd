% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/treat_assign.R
\name{treat_assign}
\alias{treat_assign}
\title{Treatment Assignment for Regression Discontinuity}
\usage{
treat_assign(x, cut = 0, t.design = "l")
}
\arguments{
\item{x}{A numeric vector containing the assignment variable, \code{x}.}

\item{cut}{A numeric value containing the cutpoint at which assignment to the treatment is determined. The default is 0.}

\item{t.design}{A string specifying the treatment option according to design.
Options are \code{"g"} (treatment is assigned if \code{x} is greater than its cutoff),
\code{"geq"} (treatment is assigned if \code{x} is greater than or equal to its cutoff),
\code{"l"} (treatment is assigned if \code{x} is less than its cutoff),
and \code{"leq"} (treatment is assigned if \code{x} is less than or equal to its cutoff).
The default is \code{"l"}.}
}
\value{
\code{treat_assign} returns the treatment variable as a vector according to the design,
  where 1 means the treated group and 0 means the control group.
}
\description{
\code{treat_assign} computes the treatment variable, \code{t}, based on the cutoff of 
assignment variable, \code{x}.
This is an internal function and is typically not directly invoked by the user. 
It can be accessed using the triple colon, as in rddapp:::treat_assign().
}
