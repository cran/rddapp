% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/attr_check.R
\name{attr_check}
\alias{attr_check}
\title{Attrition Checks}
\usage{
attr_check(x1, y, t, x2 = NULL)
}
\arguments{
\item{x1}{A numeric object, the assignment variable.}

\item{y}{A numeric object, the outcome variable, with the same dimensionality 
as \code{x}.}

\item{t}{A numeric object, the treatment variable, with the same dimensionality 
as \code{x} and \code{y}.}

\item{x2}{A numeric object, the secondary assignment variable.}
}
\value{
A list with the missing data numbers and percentages for all variables 
  and subgroups by treatment.
}
\description{
\code{attr_check} reports missing data on treatment variable, assignment variable, and outcome.
Currently it only supports the design with one assignment variable.
This is an internal function and is typically not directly invoked by the user. 
It can be accessed using the triple colon, as in rddapp:::attr_check().
}
