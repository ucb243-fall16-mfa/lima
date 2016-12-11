#' @include mfa.r
# Bootstrap
#' @title Bootstrap
#' @description Return a matrix of bootstrap ratio.
#' @param object an \code{mfa} object
#' @param nbt a positive integer of a bootstrap sample size
#' @return a matrix of bootstrap ratio
#' @export
#' @examples
#' ndatas<-apply(wine,2,function(x){ (x-mean(x))/norm(x-mean(x),type="2")})
#' test<-mfa(ndatas,sets=list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53),
#'           center=FALSE,scale=FALSE)
#' 
#' # default
#' bootstrap(test)
#' 
#' # change size 
#' bootstrap(test,nbt=5000)

setGeneric("bootstrap",function(object,nbt=1000)standardGeneric("bootstrap"))


#' @export

setMethod("bootstrap",signature="mfa",
          function(object,nbt=1000){
          if(nbt<=0||nbt%%1!=0) {stop("nbt should be a positive integer.")}
          groups<-length(object@partial_factor_score)
          series<-sample(c(seq(1:groups)),nbt*groups,TRUE)
          bts<-data.frame(table(series))
          F<-matrix(0,dim(object@partial_factor_score[[1]])[1],dim(object@partial_factor_score[[1]])[2])
          for (i in 1:groups){
            F<-F+bts[i,2]*object@partial_factor_score[[i]]
          }
          MEAN<-F/(nbt*groups)
          F1<-matrix(0,dim(object@partial_factor_score[[1]])[1],dim(object@partial_factor_score[[1]])[2])
          for (i in 1:nbt){
            temp<-matrix(0,dim(object@partial_factor_score[[1]])[1],dim(object@partial_factor_score[[1]])[2])
            for (ii in 1:groups){
              s<-(i-1)*groups+ii
              temp<-temp+object@partial_factor_score[[series[s]]]
            }
          F1<-F1+(temp/groups-MEAN)*(temp/groups-MEAN)
          }
          VAR<-F1/nbt
          return(MEAN/sqrt(VAR))
          })
