
shinyUI(fluidPage(
  
  titlePanel("Fitbit Historical Data Analysis"),
  
  sidebarLayout(
    
        sidebarPanel(
                  
                helpText("Personal Fitness monitoring is becoming an increasingly 
                         common part of ones wellness routine.  The Fitbit tracker is a popular tool and its web-site
                          collects the tracker data, but the web-site does not allow easy visualization nor analysis 
                         of the data.  This web-app provides some analysis and visualization of the author's fitness data over a customizable time-frame.  For illustrative purposes, 
                         this app uses the authors fitbit account from when he began using a fitbit in 2010."),
                
                helpText("The author's tracker only started monitoring floors climbed and Activity minutes on January 1, 2012, and heart-rate on 
                         March 17, 2015.  To visualize these parameters, the start-date slider needs to have a value after that date."),
                br(),
                sliderInput("date_range", 
                            "Choose Date Range:", 
                            min = as.Date("2010-01-20"), max = Sys.Date(), 
                            value = c(as.Date("2010-01-20"), Sys.Date())
                ),
                uiOutput("activityControl")
               
        ),
    
    mainPanel(
            
            tabsetPanel(
                    tabPanel("Visualization", plotOutput("map")),
                    tabPanel("Summary Data", htmlOutput("text")),
                    tabPanel("Intraday Data", plotOutput("daily")),
                    tabPanel("Documentation", htmlOutput("doc"))
            )
      )
    
    )
 
))