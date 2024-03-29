#' Determine Type of Regression Discontinuity Design
#' 
#' \code{rd_type} cross-tabulates observations based on (1) a binary treatment and 
#' (2) one or two assignments and their cutoff values.
#' This is an internal function and is typically not directly invoked by the user. 
#' It can be accessed using the triple colon, as in rddapp:::rd_type().
#'
#' @param data A \code{data.frame}, with each row representing an observation.
#' @param treat A string specifying the name of the numeric treatment variable (treated = positive values).
#' @param assign_1 A string specifying the variable name of the primary assignment.
#' @param cutoff_1 A numeric value containing the cutpoint at which
#'    assignment to the treatment is determined, for the primary assignment.
#' @param operator_1 The operator specifying the treatment option according to design for the primary assignment.
#'   Options are  
#'   \code{"g"} (treatment is assigned if \code{x1} is greater than its cutoff),
#'   \code{"geq"} (treatment is assigned if \code{x1} is greater than or equal to its cutoff),
#'   \code{"l"} (treatment is assigned if \code{x1} is less than its cutoff),
#'   and \code{"leq"} (treatment is assigned if \code{x1} is less than or equal to its cutoff). 
#' @param assign_2 An optional string specifying the variable name of the secondary assignment.
#' @param cutoff_2 An optional numeric value containing the cutpoint at which
#'    assignment to the treatment is determined, for the secondary assignment.
#' @param operator_2 The operator specifying the treatment option according to design for the secondary assignment.  
#'  Options are  
#'   \code{"g"} (treatment is assigned if \code{x2} is greater than its cutoff),
#'   \code{"geq"} (treatment is assigned if \code{x2} is greater than or equal to its cutoff),
#'   \code{"l"} (treatment is assigned if \code{x2} is less than its cutoff),
#'   and \code{"leq"} (treatment is assigned if \code{x2} is less than or equal to its cutoff).
#' @return \code{rd_type} returns a list of two elements:
#' \item{crosstab}{The cross-table as a data.frame. Columns in the dataframe include
#'   treatment rules, number of observations in the control condition,
#'   number of observations in the treatment condition, and the probability of an
#'   observation being in treatment or control.}
#' \item{type}{A string specifying the type of design used, either \code{"SHARP"} or \code{"FUZZY"}.}
#' 
#' @importFrom stats reshape xtabs
#'
#' @include treat_assign.R
#' 
#' @examples
#' set.seed(12345)
#' x <- runif(1000, -1, 1)
#' cov <- rnorm(1000)
#' y <- 3 + 2 * x + 3 * cov + 10 * (x >= 0) + rnorm(1000)
#' df <- data.frame(cbind(y, x, t = x>=0))
#' rddapp:::rd_type(df, 't', 'x', 0, 'geq')

rd_type <- function(data, treat, assign_1, cutoff_1, operator_1 = NULL, 
  assign_2 = NULL, cutoff_2 = NULL, operator_2 = NULL) {
  #################################################
  ## Cross-tabulate observations per assignments ##
  #################################################
  
  if (is.null(assign_2) | is.null(cutoff_2)) {
    if (is.null(operator_1)){
      stop("Specify operator_1.")
    }

    data$tstar_1 <- treat_assign(data[assign_1], cutoff_1, operator_1)
    xdf <- as.data.frame(xtabs(
      formula = substitute(
        ~ factor(tstar_1, 
          levels = c(0, 1),
          labels = 
            if (grepl("g", operator_1)) 
              paste(ifelse(rep(treat_cutoff1, 2), c("<", "\u2265"), c("\u2264", ">")), cutoff_1)
            else
              paste(ifelse(rep(treat_cutoff1, 2), c(">", "\u2264"), c("\u2265", "<")), cutoff_1)
        ) + factor(treat > 0, c(FALSE, TRUE)), 
        env = list(
          treat = as.name(treat),
          cutoff_1 = cutoff_1,
          operator_1 = operator_1,
          treat_cutoff1 = grepl("eq", operator_1))),
      data = data
    ))
    
    xdf <- setNames(xdf, c("a1", "t", "freq"))
    xdf <- xdf[order(xdf$a1), ]
    
    xdf <- reshape(xdf, direction = "wide", v.names = "freq", timevar = "t", idvar = "a1")
    
    xdf$prob =  xdf$freq.TRUE/(xdf$freq.FALSE + xdf$freq.TRUE)
    # # GET COEFFICIENTS OF X>=C FROM ESTIMATE FIRST STAGE OF 2SLS
    # 
    # fml <- substitute(
    #   trt ~ 0 
    #   + I(1-tstar_1) 
    #   + tstar_1 
    #   + I((X - C) * (1 - tstar_1)) 
    #   + I((X - C) * (tstar_1)), 
    #   env = list(
    #     trt = as.name(treat), 
    #     tstar_1 = as.name("tstar_1"),
    #     C = cutoff_1, 
    #     X = as.name(assign_1)))
    # 
    # xdf <- cbind(xdf, round(coef(lm(fml, data))[1:2], 3))
    
    colnames(xdf) <- c("A1", "Control", "Treat", "Prob.")
    
  } else {

    if (is.null(operator_1) || is.null(operator_2)){
      stop("Specify operator_1 and operator_2.")
    }

    data$tstar_1 <- treat_assign(data[assign_1], cutoff_1, operator_1)
    data$tstar_2 <- treat_assign(data[assign_2], cutoff_2, operator_2)
    xdf <- as.data.frame(xtabs(
      formula = substitute(
        ~ factor(tstar_1, 
          levels = c(0, 1),
          labels = 
            if(grepl("g", operator_1)) 
              paste(ifelse(rep(treat_cutoff1, 2), c("<", "\u2265"), c("\u2264", ">")), cutoff_1)
            else
            paste(ifelse(rep(treat_cutoff1, 2), c(">", "\u2264"), c("\u2265", "<")), cutoff_1)
        )
        + factor(tstar_2,
          levels = c(0, 1),
          labels = 
            if(grepl("g", operator_2)) 
              paste(ifelse(rep(treat_cutoff2,2), c("<","\u2265"), c("\u2264",">")), cutoff_2)
          else
            paste(ifelse(rep(treat_cutoff2,2), c(">","\u2264"), c("\u2265","<")), cutoff_2)
        )
        + factor(treat > 0, c(FALSE, TRUE)), 
        env = list(treat = as.name(treat),
          # tstar_1 = treat_assign(data[assign_1], cutoff_1, operator_1),
          cutoff_1 = cutoff_1,
          operator_1 = operator_1,
          treat_cutoff1 = grepl("eq", operator_1),
          # tstar_2 = treat_assign(data[assign_2], cutoff_2, operator_2),
          cutoff_2 = cutoff_2,
          operator_2 = operator_2,
          treat_cutoff2 = grepl("eq", operator_2))),
      data = data
    ))
    
    xdf <- setNames(xdf, c("a1", "a2", "t", "freq"))
    xdf <- xdf[order(xdf$a1), ]
    
    xdf <- reshape(xdf, direction = "wide", v.names = "freq", timevar = "t", idvar = c("a1", "a2"))
    is.na(xdf)[c(2, 4), 1] <- TRUE
    
    xdf$prob =  xdf$freq.TRUE/(xdf$freq.FALSE + xdf$freq.TRUE)
    # # GET COEFFICIENTS OF X>=C FROM ESTIMATE FIRST STAGE OF 2SLS
    # 
    # fml <- substitute(
    #   trt ~ 0 
    #   + I((1-tstar_1) * (1-tstar_2)) 
    #   + I((1-tstar_1) * tstar_2)  
    #   + I(tstar_1 * (1-tstar_2))  
    #   + I(tstar_1 * tstar_2)    
    #   + I((X1 - C1) * (X2 - C2) * (1-tstar_1) * (1-tstar_2)) 
    #   + I((X1 - C1) * (X2 - C2) * (1-tstar_1) * tstar_2)   
    #   + I((X1 - C1) * (X2 - C2) * tstar_1 * (1-tstar_2))   
    #   + I((X1 - C1) * (X2 - C2) * tstar_1 * tstar_2),
    #   env = list(
    #     trt = as.name(treat), 
    #     C1 = cutoff_1, X1 = as.name(assign_1), tstar_1 = as.name("tstar_1"), 
    #     C2 = cutoff_2, X2 = as.name(assign_2), tstar_2 = as.name("tstar_2")
    #   )
    # )
    #  
    # coef(lm(fml, data))
    # xdf <- cbind(xdf, round(coef(lm(fml, data))[1:4], 3))
    
    colnames(xdf) <- c("A1", "A2", "Control", "Treat", "Prob.")
  }
  
  ########################################
  ## Determine RD Design based on "xdf" ##
  ########################################
  
  if (sum(xdf$Control) == 0) {
    warning("No controlled case.")
    return(list(crosstab = xdf, type = "UNDEFINED"))
  }
  
  if (sum(xdf$Treat) == 0) {
    warning("No treated case.")
    return(list(crosstab = xdf, type = "UNDEFINED"))
  }
  
  if (xdf$Prob.[1] == 1) {
    warning("All controlled cases per the design are actually treated.")
    return(list(crosstab = xdf, type = "UNDEFINED"))
  }
  
  if (nrow(xdf) == 2) {
    dmat <- as.matrix(xdf[, 2:3] > 0)  # a 2x2 matrix
    if (length(which(dmat)) == 2) {
      # DEGENERATED CASES
      if (all(dmat == matrix(c(1, 0, 1, 0), 2)) | all(dmat == matrix(c(0, 1, 0, 1), 2))) {
        warning(sprintf("Invalid assign_1: %s", assign_1))
        return(list(crosstab = xdf, type = "UNDEFINED"))
      }
      
      # Sharp Design (1: n > 0, 0: n = 0)
      # 0   1  |  1   0
      # 1   0  |  0   1
      if (all(dmat == matrix(c(1, 0, 0, 1), 2)) | all(dmat == matrix(c(0, 1, 1, 0), 2))) 
        return(list(crosstab = xdf, type = "SHARP"))
    } 
    
    # Fuzzy Design
    # 1   1 | 0   1 | 1   0 | 1   1 | 1   1 |
    # 1   0 | 1   1 | 1   1 | 0   1 | 1   1 |
    if (length(which(dmat)) %in% 3:4) 
      return(list(crosstab = xdf, type = "FUZZY"))
  }
  
  ## FRONTIER DESIGNS 
  if (nrow(xdf) == 4) {
    dmat <- as.matrix(xdf[, 3:4] > 0)  # a 4x2 matrix
    rownames(dmat) <- NULL
    
    # DEGENERATED CASES 1 (X: n >= 0)
    # X X | 0 0 | 0 X | X 0 
    # X X | 0 0 | X 0 | 0 X
    # 0 0 | X X | 0 X | X 0
    # 0 0 | X X | X 0 | 0 X
    
    if (all(!dmat[1:2, ])
      | all(!dmat[3:4, ])
      | (all(!dmat[c(1, 3), 1]) & all(!dmat[c(2, 4), 2]))
      | (all(!dmat[c(2, 4), 1]) & all(!dmat[c(1, 3), 2]))) {
      warning(sprintf("Ineffective assign_1: %s", assign_1))
      return(list(crosstab = xdf, type = "UNDEFINED"))
    }
    
    # Ineffective assign_2
    #  0 0 | X X | 0 X | X 0
    #  X X | 0 0 | 0 X | X 0
    #  0 0 | X X | X 0 | 0 X
    #  X X | 0 0 | X 0 | 0 X
    
    if (all(!dmat[c(1,3),])
      | all(!dmat[c(2,4),])
      | (all(!dmat[1:2,1]) & all(!dmat[3:4,2]))
      | (all(!dmat[1:2,2]) & all(!dmat[3:4,1]))) {
      warning(sprintf("Ineffective assign_2: %s", assign_2))
      return(list(crosstab = xdf, type = "UNDEFINED"))
    } 
    
    # SHARP FRONTIER designs
    # 0 X | 1 0
    # 0 X | 0 X
    # 0 X | 0 X
    # 1 0 | 0 X  
    
    if ((all(!dmat[1:3, 1]) & dmat[4, 1] & !dmat[4, 2]) 
      | (all(!dmat[2:4, 1]) & dmat[1, 1] & !dmat[1, 2])) {
      if (all((xtabs(paste0(treat, " ~ tstar_1 + tstar_2"), data) > 0) == matrix(c(0, 1, 1, 1), 
        nrow = 2, byrow = TRUE))) {
        return(list(crosstab = xdf, type = "SHARP FRONTIER"))
      } 
      else {
        warning(sprintf("Undefined frontier design"))
        return(list(crosstab = xdf, type = "UNDEFINED"))
      }
    }
    
    # FUZZY FRONTIER designs (Z: any(n\u22650) among Z; X: any(n\u22650) among X)
    # Z X | 1 Z
    # Z X | Z X
    # Z X | Z X
    # 1 Z | Z X  
    
    else if ((dmat[4, 1] & any(dmat[1:3, 2])) | (dmat[1, 1] & any(dmat[2:4, 2]))) {
      return(list(crosstab = xdf, type = "FUZZY FRONTIER"))
    } 
    else {
      warning(sprintf("Undefined frontier design"))
      return(list(crosstab = xdf, type = "UNDEFINED"))
    }
  }
}