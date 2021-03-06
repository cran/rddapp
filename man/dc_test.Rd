% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dc_test.R
\name{dc_test}
\alias{dc_test}
\title{McCrary Sorting Test}
\usage{
dc_test(
  runvar,
  cutpoint,
  bin = NULL,
  bw = NULL,
  verbose = TRUE,
  plot = TRUE,
  ext.out = FALSE,
  htest = FALSE,
  level = 0.95,
  digits = max(3, getOption("digits") - 3),
  timeout = 30
)
}
\arguments{
\item{runvar}{Numerical vector of the running variable.}

\item{cutpoint}{The cutpoint (defaults to 0).}

\item{bin}{The binwidth (defaults to \code{2*sd(runvar)*length(runvar)^(-.5)}).}

\item{bw}{The bandwidth to use (by default uses bandwidth selection calculation 
from McCrary (2008)).}

\item{verbose}{Logical flag specifying whether to print diagnostic information to 
the terminal (defaults to \code{TRUE}).}

\item{plot}{Logical flag indicating whether to plot the histogram and density estimations 
(defaults to \code{TRUE}). The user may wrap this function in additional graphical options 
to modify the plot.}

\item{ext.out}{Logical flag indicating whether to return extended output. 
When \code{FALSE} (the default) \code{DCdensity} will return only the p-value of the test. 
When \code{TRUE}, \code{DCdensity} will return the additional information documented below.}

\item{htest}{Logical flag indicating whether to return an \code{"htest"} object 
compatible with base R's hypothesis test output.}

\item{level}{Numerical value between 0 and 1. Confidence level for confidence intervals.}

\item{digits}{Number of digits to display.}

\item{timeout}{Numerical value specifying the maximum number of seconds (defaults to 30 seconds) 
expressions in the function are allowed to run. Specify \code{Inf} to run all expressions
to completion.}
}
\value{
If \code{ext.out} is \code{FALSE}, only the p value will be returned. 
  Additional output is enabled when \code{ext.out} is \code{TRUE}. 
  In this case, a list will be returned with the following elements:
\item{theta}{The estimated log difference in heights at the cutpoint.}
\item{se}{The standard error of \code{theta}.}
\item{z}{The z statistic of the test.}
\item{p}{The p-value of the test. A p-value below the significance threshold indicates 
  that the user can reject the null hypothesis of no sorting.}
\item{binsize}{The calculated size of bins for the test.}
\item{bw}{The calculated bandwidth for the test.}
\item{cutpoint}{The cutpoint used.}
\item{data}{A dataframe for the binning of the histogram. Columns are \code{cellmp} 
  (the midpoints of each cell) and \code{cellval} (the normalized height of each cell).}
}
\description{
\code{dc_test} implements the McCrary (2008) sorting test.
It is based on the \code{\link[rdd]{DCdensity}} function in the \pkg{rdd} package.
}
\examples{
# No discontinuity
x <- runif(1000, -1, 1)
dc_test(x, 0)

# Discontinuity
x <- runif(1000, -1, 1)
x <- x + 2 * (runif(1000, -1, 1) > 0 & x < 0)
dc_test(x, 0)
}
\references{
McCrary, J. (2008).
  Manipulation of the running variable in the regression discontinuity design: A density test. 
  Journal of Econometrics, 142(2), 698-714. 
  \url{http://dx.doi.org/10.1016/j.jeconom.2007.05.005}.
}
