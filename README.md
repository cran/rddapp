rddapp
==================================================
[![Downloads](http://cranlogs.r-pkg.org/badges/rddapp)](https://CRAN.R-project.org/package=rddapp) [![Cran Build](https://www.r-pkg.org/badges/version/rddapp)](https://CRAN.R-project.org/package=rddapp)
[![R-CMD-check](https://github.com/felixthoemmes/rddapp/actions/workflows/r.yml/badge.svg)](https://github.com/felixthoemmes/rddapp/actions/workflows/r.yml)

Overview
--------------------------------------------------

**rddapp** provides a set of functions for the analysis of the regression-discontinuity design (RDD). 

The three main parts are:

- Estimation of effects of interest  
- Power analysis  
- Assumption checks  


Estimation
--------------------------------------------------
The package estimates treatment effects from RDDs for the following designs and approaches:

 - Parametric RDD with single assignment variables (both sharp and fuzzy designs)   
 - Non-parametric RDD with single assignment variables (both sharp and fuzzy designs)  
 - Parametric RDDs with two assignment variables (both sharp and fuzzy designs), using univariate, centering, and frontier approaches  


Power analysis
--------------------------------------------------
Given input from the user about desired Type I error rate and assumptions about the population, the package allows estimation of power for the following designs:

- Single assignment RDDs (both sharp and fuzzy) using both parametric and non-parametric estimation  
- Multiple-assignment RDDs (both sharp and fuzzy) using various parametric models 


Assumption checks
--------------------------------------------------
The package allows the user to perform a variety of assumption and sensitivity checks, including:

- McCrary's sorting test on the assignment variable  
- Sensitivity to the chosen bandwidth in non-parametric estimation  
- Placebo tests to examine treatment effects at values away from the cut-off  
- Discontinuities in the treatment probability at cut-off  
- Discontinuities for baseline covariates  

Installation
--------------------------------------------------

``` r
# Install the released version from CRAN
install.packages("rddapp")

# Or the development version from GitHub:
# install.packages("devtools")
devtools::install_github("felixthoemmes/rddapp")
```
