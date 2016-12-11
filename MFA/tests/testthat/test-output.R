context("Test MFA output")

testthat::test_that("TestOutPut",{
  testdata = scale(mtcars)
  testset = list(1:5,6:11)
  ##test LG
  testthat::expect_that(round(LG(testdata,testdata),2),testthat::equals(1.17))
  
  ##test LG_table
  lg_table = matrix(c(1.02,0.98,0.98,1.77),2,2)
  testthat::expect_that(LG_table(testdata,testset),testthat::is_a("matrix"))
  testthat::expect_that(round(LG_table(testdata,testset),2),testthat::equals(lg_table))
  
  ##test RV
  testthat::expect_that(RV(testdata,testdata),testthat::is_a("numeric"))
  testthat::expect_that(RV(testdata,testdata),testthat::equals((1)))
  
  #test RV_table
  rv_table = matrix(c(1,0.73,0.73,1),2,2)
  testthat::expect_that(RV_table(testdata,testset),testthat::is_a("matrix"))
  testthat::expect_that(round(RV_table(testdata,testset),2),testthat::equals(rv_table))
  
  #test bootstrap
  testmfa = mfa(testdata,testset)
  testthat::expect_that(bootstrap(testmfa,nbt = 10),testthat::is_a("matrix"))
  
  #test contributions
  testthat::expect_that(contributions(testmfa),testthat::is_a("list"))
  testthat::expect_that(names(contributions(testmfa)),testthat::equals(c("observations","variables","table")))
  
  #test print
  #testthat::expect_that(print(mfa),testthat::prints_text(NULL))
  
  #test eigenvalues
  testthat::expect_that(eigenvalues(testmfa),testthat::is_a("data.frame"))
  testthat::expect_that(round(eigenvalues(testmfa)[1,1],2),testthat::equals(0.25))
  
  #test wine
  sets=list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53)
  #To make clean data
  ndatas<-apply(wine,2,function(x){ (x-mean(x))/norm(x-mean(x),type="2")})
  
  ##test LG
  testthat::expect_that(round(LG(ndatas,ndatas),2),testthat::equals(1.06))
  
  ##test LG_table
  wlg_table = matrix(c(1.06,0.92,0.92,1.06),2,2)
  testthat::expect_that(LG_table(ndatas,sets),testthat::is_a("matrix"))
  testthat::expect_that(round(LG_table(ndatas,sets)[1:2,1:2],2),testthat::equals(wlg_table))
  
  #test bootstrap
  wtestmfa = mfa(ndatas,sets)
  testthat::expect_that(bootstrap(wtestmfa,nbt = 10),testthat::is_a("matrix"))
  
  #test contributions
  testthat::expect_that(contributions(wtestmfa),testthat::is_a("list"))
  testthat::expect_that(names(contributions(wtestmfa)),testthat::equals(c("observations","variables","table")))
  
  #test print
  #testthat::expect_that(print(wtestmfa),testthat::prints_text(NULL))
  
  #test eigenvalues
  testthat::expect_that(eigenvalues(wtestmfa),testthat::is_a("data.frame"))
  testthat::expect_that(round(eigenvalues(wtestmfa)[1,1],2),testthat::equals(0.88))
})

