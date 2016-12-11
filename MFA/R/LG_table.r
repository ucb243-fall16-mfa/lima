
#' @title Lg Coefficients Table
#' @description Return a table of Lg coefficients between any two subsets of a normalized dataset.
#' @param dataset a normalized dataframe or matrix
#' @param sets list of vector contains vector of indices or variable names of each group
#' @return a table of Lg coefficients
#' @export
#' @examples
#' # numeric sets
#' ndatas<-apply(wine,2,function(x){ (x-mean(x))/norm(x-mean(x),type="2")})
#' LG_table(ndatas,sets=list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53))
#' 
#' # character sets
#' ndatas<-apply(wine,2,function(x){ (x-mean(x))/norm(x-mean(x),type="2")})
#' # Use the first and last variable names of each group:
#' LG_table(ndatas,sets=list(c("V1.G1","V6.G1"),c("V1.G2","V8.G2"),c("V1.G3","V10.G3"),
#'                            c("V1.G4","V8.G4"),c("V1.G5","V12.G5"),c("V1.G6","V13.G6"),
#'                            c("V1.G7","V4.G7"),c("V1.G8","V5.G8"),c("V1.G9","V15.G9"),
#'                            c("V1.G10","V4.G10")))
#' # or use the full list of variable names of each group:
#' LG_table(ndatas,sets=list(c("V1.G1","V2.G1","V3.G1","V4.G1","V5.G1","V6.G1"),
#'                            c("V1.G2","V2.G2","V3.G2","V4.G2","V7.G2","V8.G2"),
#'                            c("V1.G3","V2.G3","V3.G3","V4.G3","V9.G3","V10.G3"),
#'                            c("V1.G4","V2.G4","V3.G4","V4.G4","V8.G4"),
#'                            c("V1.G5","V2.G5","V3.G5","V4.G5","V11.G5","V12.G5"),
#'                            c("V1.G6","V2.G6","V3.G6","V4.G6","V13.G6"),
#'                            c("V1.G7","V2.G7","V3.G7","V4.G7"),
#'                            c("V1.G8","V2.G8","V3.G8","V4.G8","V14.G8","V5.G8"),
#'                            c("V1.G9","V2.G9","V3.G9","V4.G9","V15.G9"),
#'                            c("V1.G10","V2.G10","V3.G10","V4.G10")))

LG_table <- function(dataset,sets){
  if(!is.data.frame(dataset)&!is.matrix(dataset)){stop("dataset must be a matrix or a dataframe.")}
  dataset <-as.matrix(dataset)
  if(!is.numeric(dataset)) {stop("dataset must be a numeric matrix or dataframe.")}
  
  # check sets
  if(is.numeric(sets[[1]])){
    check_sets<-NULL
    for (i in 1:length(sets)) {
      if(!is.numeric(sets[[i]])) {stop("sets should be a list of numeric vectors or character vectors.")}
      check_sets<-c(check_sets,sets[[i]])
    }
    if(length(check_sets)!=ncol(dataset)) {stop("The sum of sets lengths does not equal to the number of columns.")}
    if(any(!check_sets%in%1:ncol(dataset))) {stop("sets out of bounds")}
    if(!identical(1:ncol(dataset),check_sets)) {warning("sets contain some overlapped and skipped columns.")}
  }else{
    if(is.character(sets[[1]])){
      check_sets<-NULL
      check_names<-NULL
      for (i in 1:length(sets)){
        if(!is.character(sets[[i]])) {stop("sets should be a list of character vectors or numeric vectors.")}
        if(any(!sets[[i]]%in%colnames(dataset))) {stop("sets contain wrong variable names.")}
        check_names<-c(check_names,sets[[i]])
        check_sets<-c(check_sets,c(which(colnames(dataset)==sets[[i]][1]):which(colnames(dataset)==sets[[i]][length(sets[[i]])])))
      }
      if(length(check_sets)!=ncol(dataset)) {stop("The sum of sets lengths does not equal to the number of columns, or the variable names are in the wrong order.")}
      if(length(check_names)!=2*length(sets)&&!identical(colnames(data),check_names)) {warning("sets contain some overlapped and skipped columns.")}
    }else{
      stop("sets should be a list of numeric vectors or character vectors.")
    }
  }
  
  # if sets is character: turn sets into indicies acccording to rownames of dataset
  osets<-sets
  if (!is.numeric(sets[[1]])){
    newlist<-list()
    for (i in 1:length(sets)){
      newlist[[i]]<-c(which(colnames(dataset)==sets[[i]][1]):which(colnames(dataset)==sets[[i]][length(sets[[i]])]))
    }
    sets<-newlist
  }
  
  #computation
  Table <- matrix(NA,length(sets),length(sets))
  for(i in 1:length(sets)){
    for(j in i:length(sets)){
      lg <- LG(as.matrix(dataset[,sets[[i]]]),as.matrix(dataset[,sets[[j]]]))
      Table[i,j] <- lg
      Table[j,i] <- lg
     }
  }
  Table
}

