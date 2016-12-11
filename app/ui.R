
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#
library(markdown)
library(shiny)
library(DT)

shinyUI(fluidPage(theme = "bootstrap0.css",
  
  #Title
  headerPanel(
    h1("Multiple Factor Analysis", 
       style = "font-family: 'serif', cursive;
       font-weight: 500; 
       color: #000000;")),
  HTML("
      <br>
      <div> This is the final project for class STAT243-Fall-2016. </div>
      <div> For more information about input format of the data, 
       <a href='https://github.com/MFA-Rpackage/dev/blob/master/mfa_vignette.html'>click here</a>. </div> 
       <div> To see the online version published on Rstuio, 
       <a href='https://zyz2012.shinyapps.io/ShinyApp/'>click here</a>. </div> 
       "),
  br(),
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      #Choose Data and Sets
      fileInput('file1', 'Choose Data File (.csv)',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')),
      fileInput('file2','Choose Sets File (.txt)',
                accept=c('text/txt', 
                         'text/space-separated-values,text/plain', 
                         '.txt')),
      
      #Evaluate Dim
      splitLayout(
        uiOutput("dim1"),
        uiOutput("dim2")
      ),
      
      #Tableoutput
      absolutePanel(
        top = 340, left = 20, width = 350,height = 'auto',
        draggable = TRUE,
        wellPanel(
          HTML(markdownToHTML(fragment.only=TRUE, text=c(
            "**Plotting Value**:"
          ))),
          verbatimTextOutput("plottingValue"),
          conditionalPanel(
            'input.PlotValue === "The Loadings"',
            dataTableOutput('ex4',width = "100%")
          ),
          conditionalPanel(
            'input.PlotValue === "Common Factor Scores"',
            dataTableOutput('ex2',width = "100%")
          ),
          conditionalPanel(
            'input.PlotValue === "Eigenvalues"',
            dataTableOutput('ex1',width = "100%")
          ),
          conditionalPanel(
            'input.PlotValue === "Partial Factor Scores"',
            #selectInput("Group", "Group Number",choices = ),
            uiOutput("group"),
            dataTableOutput('ex3',width = "100%")
          )
        ),
        style = "opacity: 0.92"
      )
    ),

    # Show a plot of the generated distribution
    mainPanel(
      navbarPage(
        id = 'PlotValue',
        title = "Plot:",
        tabPanel("Eigenvalues", plotOutput("eigenPlot")),
        tabPanel("Common Factor Scores", plotOutput("commonPlot")),
        tabPanel("Partial Factor Scores", plotOutput("scorePlot")),
        tabPanel("The Loadings",plotOutput("loadingsPlot")))
    )
  )
))
