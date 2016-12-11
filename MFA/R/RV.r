
#' @title Rv Coefficients
#' @description Return a value of Rv coefficient between two tables.
#' @param table1 a normalized data matrix or data.frame
#' @param table2 a normalized data matrix or data.frame
#' @return a value of Rv coefficient between two tables
#' @export
#' @examples
#' # default 
#' ndatas<-apply(wine,2,function(x){ (x-mean(x))/norm(x-mean(x),type="2")})
#' x1 <- ndatas[,1:6]
#' x2 <- ndatas[,7:12]
#' RV(x1,x2)

# set funtion RV() to take two tables and return rv coefficient
RV<-function(table1,table2){
  #To check input data
  if(!is.matrix(table1)&&!is.data.frame(table1)) {stop("data should be numeric matrix or data.frame")}
  if(!is.matrix(table2)&&!is.data.frame(table2)) {stop("data should be numeric matrix or data.frame")}
  table1<-as.matrix(table1)
  table2<-as.matrix(table2)
  if(!is.numeric(table1)) {stop("data should be numeric matrix or data.frame")}
  if(!is.numeric(table2)) {stop("data should be numeric matrix or data.frame")}
  
  t1 <- t(table1)
	t2 <- t(table2)
  sum(diag((table1 %*% t1) %*% (table2 %*% t2)))/sqrt(sum(diag((table1 %*% t1) %*% (table1 %*% t1)))*sum(diag((table2 %*% t2) %*% (table2 %*% t2))))
}
