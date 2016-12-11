testset <-  list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)
nonnumeric_data <- wine
nonnumeric_data[1,1] <- "8"
ndata1 <- nonnumeric_data[,1:6]
ndata2 <- nonnumeric_data[,7:12]
context("Test MFA arguments")
test_that("check numeric data",{
  #check numeric data
  expect_error(mfa(nonnumeric_data,sets = testset),
               "data should be numeric matrix or data.frame")
})

test_that("check center and scale",{
  expect_error(mfa(wine,sets = testset,center = rep("a",ncol(wine)),scale = T),
               "center should be either a logical value or a numeric vector of length equal to the number of columns of 'data'")
  expect_error(mfa(wine,sets = testset,center = T,scale = rep("b",ncol(wine))),
               "scale should be either a logical value or a numeric vector of length equal to the number of columns of 'data'")
  expect_error(mfa(wine,sets = testset,center = T,scale = rep(0,ncol(wine))),
               "scale vector can't contain zero values.")
})

test_that("check numeric sets",{
  expect_error(mfa(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,"V4.G10")),
               "sets should be a list of numeric vectors or character vectors.")
  expect_error(mfa(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49)),
               "The sum of sets lengths does not equal to the number of columns.")
  expect_error(mfa(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,51:54)),
               "Some sets are out of the range of column number of the origin dataset.")
  expect_message(expect_warning(mfa(wine,sets = list(1:5,5:11,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)),
               "sets contain some overlapped and skipped columns."),
               "Matrix is singular: outputing 11 dimensions.")
})

test_that("check character sets",{
  expect_error(mfa(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                     7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)),
               "sets should be a list of character vectors or numeric vectors.")
  expect_error(mfa(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                     c("V1.G2", "V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                     c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                     c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                     c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                     c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                     c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                     c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                     c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                     c("V1.G10", "V2.G10","V3.G10", "V5.G10"))),
               "sets contain wrong variable names.")
  expect_error(mfa(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                     c("V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                     c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                     c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                     c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                     c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                     c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                     c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                     c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                     c("V1.G10", "V2.G10","V3.G10", "V4.G10"))),
               "The sum of sets lengths does not equal to the number of columns, or the variable names are in the wrong order.")
  expect_message(expect_warning(mfa(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                                      c("V1.G2", "V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                                      c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                                      c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                                      c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                                      c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                                      c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                                      c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                                      c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                                      c("V1.G10", "V2.G10", "V4.G10"))),
                                "sets contain some overlapped and skipped columns."),
                 "Matrix is singular: outputing 11 dimensions.")
})

test_that("check singularity and ncomps",{
  expect_error(mfa(wine,sets = testset,ncomps = -2),
               "ncomps should be positive integer.")
  expect_warning(mfa(wine,sets = testset,ncomps = 12),
                 "ncomps larger than rank: outputing 11 dimensions.")
  expect_message(mfa(wine,sets = testset),
                 "Matrix is singular: outputing 11 dimensions.")
})

test_that("check plot input",{
  test <- mfa(wine,testset)
  expect_error(plot(test,dim=1),"dim should be a integer vector of two values.")
  expect_error(plot(test,dim=c(12,1)),"dim out of bounds.")
  expect_error(plot(test,dim=c(1,1),singleoutput = "cm"),
               "singleoutput can only take a character value among 'eig','com','par'.")
})




context("Test Rv and Rv table arguments")

test_that("check Rv input",{
  expect_error(RV(ndata1,ndata2),"data should be numeric matrix or data.frame")
})

test_that("check Rv table sets",{
  
  expect_error(RV_table(c(1,2,2,2,2,1,42,35,26),sets = testset),
               "dataset must be a matrix or a dataframe.")
  expect_error(RV_table(nonnumeric_data,sets = testset),
               "dataset must be a numeric matrix or dataframe.")
  expect_error(RV_table(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,"V4.G10")),
               "sets should be a list of numeric vectors or character vectors.")
  expect_error(RV_table(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49)),
               "The sum of sets lengths does not equal to the number of columns.")
  expect_error(RV_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                          7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)),
               "sets should be a list of character vectors or numeric vectors.")
  expect_error(RV_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                          c("V1.G2", "V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                          c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                          c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                          c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                          c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                          c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                          c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                          c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                          c("V1.G10", "V2.G10","V3.G10", "V5.G10"))),
               "sets contain wrong variable names.")
  expect_error(RV_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                          c("V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                          c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                          c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                          c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                          c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                          c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                          c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                          c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                          c("V1.G10", "V2.G10","V3.G10", "V4.G10"))),
               "The sum of sets lengths does not equal to the number of columns, or the variable names are in the wrong order.")
  expect_warning(RV_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                            c("V1.G2", "V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                            c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                            c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                            c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                            c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                            c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                            c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                            c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                            c("V1.G10", "V2.G10", "V4.G10"))),
                 "sets contain some overlapped and skipped columns.")
  
})




context("Test Lg and Lg table arguments")

test_that("check Lg input",{
  expect_error(LG(ndata1,ndata2),"data should be numeric matrix or data.frame")
})

test_that("check Lg table sets",{
  
  expect_error(LG_table(c(1,2,2,2,2,1,42,35,26),sets = testset),
               "dataset must be a matrix or a dataframe.")
  expect_error(LG_table(nonnumeric_data,sets = testset),
               "dataset must be a numeric matrix or dataframe.")
  expect_error(LG_table(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,"V4.G10")),
               "sets should be a list of numeric vectors or character vectors.")
  expect_error(LG_table(wine,sets = list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49)),
               "The sum of sets lengths does not equal to the number of columns.")
  expect_error(LG_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                     7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)),
               "sets should be a list of character vectors or numeric vectors.")
  expect_error(LG_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                     c("V1.G2", "V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                     c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                     c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                     c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                     c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                     c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                     c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                     c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                     c("V1.G10", "V2.G10","V3.G10", "V5.G10"))),
               "sets contain wrong variable names.")
  expect_error(LG_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                     c("V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                     c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                     c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                     c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                     c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                     c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                     c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                     c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                     c("V1.G10", "V2.G10","V3.G10", "V4.G10"))),
               "The sum of sets lengths does not equal to the number of columns, or the variable names are in the wrong order.")
  expect_warning(LG_table(wine, sets = list(c("V1.G1", "V2.G1", "V3.G1", "V4.G1", "V5.G1", "V6.G1"), 
                                                      c("V1.G2", "V2.G2", "V3.G2", "V4.G2", "V7.G2", "V8.G2"),
                                                      c("V1.G3", "V2.G3", "V3.G3", "V4.G3","V9.G3", "V10.G3"),
                                                      c("V1.G4", "V2.G4", "V3.G4", "V4.G4", "V8.G4"),
                                                      c("V1.G5", "V2.G5", "V3.G5","V4.G5", "V11.G5", "V12.G5"),
                                                      c("V1.G6", "V2.G6", "V3.G6", "V4.G6", "V13.G6"),
                                                      c("V1.G7", "V2.G7", "V3.G7", "V4.G7"), 
                                                      c("V1.G8", "V2.G8", "V3.G8", "V4.G8", "V14.G8", "V5.G8"),
                                                      c("V1.G9", "V2.G9", "V3.G9", "V4.G9", "V15.G9"),
                                                      c("V1.G10", "V2.G10", "V4.G10"))),
                                "sets contain some overlapped and skipped columns.")
  
})

