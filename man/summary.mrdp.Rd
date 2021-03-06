% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/summary.mrdp.R
\name{summary.mrdp}
\alias{summary.mrdp}
\title{Summarize the Power Analysis of Regression Discontinuity}
\usage{
\method{summary}{mrdp}(object, digits = max(3, getOption("digits") - 3), ...)
}
\arguments{
\item{object}{An object of class \code{"mrdp"}, usually a result of a call to \code{\link{mrd_power}}.}

\item{digits}{Number of digits to display.}

\item{...}{Additional arguments.}
}
\value{
\code{summary.mrdp} returns a list which has the following components:
\item{coefficients}{A matrix containing the mean, variance, and empirical alpha of each estimator.}
}
\description{
\code{summary.mrdp} is a \code{summary} method for class \code{"mrdp"}
}
