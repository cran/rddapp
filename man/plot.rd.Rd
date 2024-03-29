% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.rd.R
\name{plot.rd}
\alias{plot.rd}
\title{Plot the Regression Discontinuity}
\usage{
\method{plot}{rd}(
  x,
  preds = NULL,
  fit_line = c("linear", "quadratic", "cubic", "optimal", "half", "double"),
  fit_ci = c("area", "dot", "hide"),
  fit_ci_level = 0.95,
  bin_n = 20,
  bin_level = 0.95,
  bin_size = c("shade", "size"),
  quant_bin = TRUE,
  xlim = NULL,
  ylim = NULL,
  include_rugs = FALSE,
  ...
)
}
\arguments{
\item{x}{An \code{rd} object, typically the result of \code{\link{rd_est}}.}

\item{preds}{An optional vector of predictions generated by \code{\link{predict.rd}}.
If not supplied, prediction is completed within the \code{plot.rd} function.}

\item{fit_line}{A character vector specifying models to be shown as fitted lines.
Options are \code{c("linear", "quadratic", "cubic", "optimal", "half", "double")}.}

\item{fit_ci}{A string specifying whether and how to plot prediction confidence intervals
around the fitted lines. Options are \code{c("area", "dot", "hide")}.}

\item{fit_ci_level}{A numeric value between 0 and 1 specifying the confidence level of prediction CIs. The default is 0.95.}

\item{bin_n}{An integer specifying the number of bins for binned data points. If \code{bin_n} is 0, raw data points are plotted.
If \code{bin_n} is < 0, data points are suppressed. The default is 20.}

\item{bin_level}{A numeric value between 0 and 1 specifying the confidence level for CIs around binned data points. The default is 0.95.}

\item{bin_size}{A string specifying how to plot the number of observations in each bin, by \code{"size"} or \code{"shape"}.}

\item{quant_bin}{A logical value indicating whether the data are binned by quantiles. The default is \code{TRUE}.}

\item{xlim}{An optional numeric vector containing the x-axis limits.}

\item{ylim}{An optional numeric vector containing the y-axis limits.}

\item{include_rugs}{A logical value indicating whether to include the 1d plot for both axes. The default is \code{FALSE}.}

\item{...}{Additional graphic arguments passed to \code{plot}.}
}
\description{
\code{plot.rd} plots the relationship between the running variable and the outcome.
It is based on the \code{plot.RD} function in the "rdd" package.
}
\examples{
set.seed(12345) 
dat <- data.frame(x = runif(1000, -1, 1), cov = rnorm(1000))
dat$tr <- as.integer(dat$x >= 0)
dat$y <- 3 + 2 * dat$x + 3 * dat$cov + 10 * (dat$x >= 0) + rnorm(1000)
rd <- rd_est(y ~ x + tr | cov, data = dat, cutpoint = 0, t.design = "geq") 
plot(rd)
}
\references{
Drew Dimmery (2016). rdd: Regression Discontinuity Estimation. R package
   version 0.57. https://CRAN.R-project.org/package=rdd
}
