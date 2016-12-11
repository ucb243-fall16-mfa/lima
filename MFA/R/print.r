#'Pringting MFAs
#'
#' @title Pringt Method for \code{mfa} Object
#' @description Pringting an \code{mfa} object.
#' @param x an object of class \code{"mfa"}
#' @param ... more arguments
#' @return Some summary information about the \code{mfa} object:
#' @return The number of components
#' @return The eigenvalue of the first component
#' @return The eigenvalue of the second component
#' @export
#' @examples 
#' test<-mfa(wine,sets=list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53))
#' print(test)

# set print() to print basic infomation
setMethod("print",
  signature="mfa",
  function(x,...){
    cat(paste("There are",length(x@eigenvalues),"components."),"\n")
    cat("The eigenvalue of the first component is: ",  x@eigenvalues[1],"\n")
    cat("The eigenvalue of the second component is: ",  x@eigenvalues[2],"\n")
  }
)