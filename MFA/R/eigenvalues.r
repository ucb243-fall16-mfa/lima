#' @include mfa.r
#' @title Eigenvalues
#' @description Returns a table with summarizing information about the obtained eigenvalues.
#' @param object an \code{mfa} object
#' @return a dafa frame contains:
#' @return \item{Singular value}{The square root of eigenvalues}
#' @return \item{Eigenvalue}{The eigenvalues of \code{mfa} object}
#' @return \item{Cumulative}{Cumulative sum of eigenvalues}
#' @return \item{precentage Inertia}{Percentage inertia of eigenvalues}
#' @return \item{Cumulative percentage Inertia}{Cumulative percentage inertia of eigenvalues}
#' @export
#' @examples 
#' test<-mfa(wine,sets=list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53))
#' eigenvalues(test)
#' 
# set eigenvalues() to take 'mfa' and return a table (like Table 2)
setGeneric("eigenvalues",function(object) standardGeneric("eigenvalues"))


#' @export
setMethod("eigenvalues",signature="mfa",
  function(object){
    eigenvalue <- object@eigenvalues
    singular_value <- sqrt(eigenvalue)
    cumulative <- cumsum(eigenvalue)
    inertia <- eigenvalue/sum(eigenvalue)*100
    cumulative_precentage <- cumulative/sum(eigenvalue)*100
    
    df <- data.frame(rbind(singular_value,eigenvalue,cumulative,inertia,cumulative_precentage))
    colnames(df) <- 1:length(eigenvalue)
    rownames(df) <- c("Singular value", "Eigenvalue","Cumulative","% Inertia","Cumulative % Inertia")
    df
  }
)
