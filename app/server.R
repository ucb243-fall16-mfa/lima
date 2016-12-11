
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

#Source MFA function
source("functions/mfa.R")
#Get the plot functions
source("functions/plotfunctions.R")


shinyServer(function(input, output) {
  
  #Reactive data input(default:wine.csv)
  newdata <- reactive({
    if(is.null(input$file1) || is.null(input$file2)){
      return(read.table("data/wine.csv",header=F,stringsAsFactors = F,sep = ','))
    }
    else{
      return(read.csv(input$file1$datapath,sep = ','))
    }
  })
  
  #Reactive sets input(default:sets.txt)
  newsets <- reactive({
    if(is.null(input$file1) || is.null(input$file2)){
      return(list(1:6,7:12,13:18,19:23,24:29,30:34,35:38,39:44,45:49,50:53))
    }
    else{
      lst = list()
      line = readLines(file(input$file2$datapath,"r"),1)
      veclist = strsplit(line,',')[[1]]
      for(i in 1:length(veclist)){
        lst[[i]] = eval(parse(text = veclist[i]))
      }
      return(lst)
    }
  })
  
  #Reactive mfa
  newtest <- reactive({
    data = newdata()
    sets = newsets()
    ndatas = cleandata(data,sets)
    #Get the mfa instance
    ntest<-mfa(ndatas,sets=sets,ncomps=NULL,center=FALSE,scale=FALSE)
    return(ntest)
  })
  
  #Reactive dim
  newdim <- reactive({
    return(c(input$Dim1,input$Dim2))
  })
  
  #Several plots
  output$eigenPlot <- renderPlot({
    test = newtest()
    eigen = test@eigenvalues
    eigendata = data.frame(Eigenvalues = eigen)
    
    plot_eigen(test)
    })
  output$commonPlot <- renderPlot({
    test = newtest()
    dim = newdim()
    plot_common(test,dim)
    })
  output$scorePlot <- renderPlot({
    test = newtest()
    x = test
    dim = newdim()
    #plot_partial(test,dim)
    
    names<-sapply(dim,function(x){paste0("Dim",x)})
    partial<-lapply(x@partial_factor_score,function(x){x[,dim]})
    loadings<- -data.frame(x@loadings[,dim])
    loadings[,1]<-loadings[,1]*(sqrt(x@eigenvalues[dim[1]])/sd(loadings[,1]))
    loadings[,2]<-loadings[,2]*(sqrt(x@eigenvalues[dim[2]])/sd(loadings[,2]))
    sets = x@sets
    plist <- list()
    i = as.numeric(input$Groupnum)
      mydata<-data.frame(partial[[i]])
      mydata[,2]<- -mydata[,2]
      mydata$id<-rownames(mydata)
      mydata2<-loadings[sets[[i]],]
      mydata2[,1]<- -mydata2[,1]
      myplot<-partial_plot(i,mydata,mydata2,names)
    
    myplot    
    
  })
  output$loadingsPlot <- renderPlot({
    test = newtest()
    dim = newdim()
    plot_loadings(test,dim)
    })
  output$plottingValue <- renderText({paste0(input$PlotValue)})
  output$ex4 <- renderDataTable({
    test = newtest()
    dim = newdim()
    datatable(round(test@loadings[,dim],2),options = list(dom = 't',initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#BBAAFF', 'color': '#fff'});",
      "}")
      ))
    })
  output$ex2 <- renderDataTable({
    test = newtest()
    dim = newdim()
    datatable(round(test@common_factor_score[,dim],2),options = list(dom = 't',initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#6699FF', 'color': '#fff'});",
      "}")
    ))
  })
  output$ex1 <- renderDataTable({
    test = newtest()
    eigen = test@eigenvalues
    eigendata = data.frame(Eigenvalues = eigen)
    datatable(round(eigendata,2),options = list(dom = 't',initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#33CC88', 'color': '#fff'});",
      "}")
    ))
  })
  output$ex3 <- renderDataTable({
    test = newtest()
    dim = newdim()
    datatable(round(test@partial_factor_score[[as.numeric(input$Groupnum)]][,dim],2),options = list(dom = 't',initComplete = JS(
      "function(settings, json) {",
      "$(this.api().table().header()).css({'background-color': '#22EEAA', 'color': '#fff'});",
      "}")
    ))
  })
  
  #Group Number Panel
  output$group <- renderUI({
    test = newtest()
    groupNum = length(test@partial_factor_score)
    selectInput("Groupnum", "Group Number", choices = 1:groupNum,selected = 1)
  })
  
  #Dim Panel
  output$dim1 <- renderUI({
    sets = newsets()
    numericInput("Dim1", "Dim 1", 1,min = 1, max = length(sets), step = 1)
  })
  output$dim2 <- renderUI({
    sets = newsets()
    numericInput("Dim2", "Dim 2", 2,min = 1, max = length(sets), step = 1)
  })
  
})
