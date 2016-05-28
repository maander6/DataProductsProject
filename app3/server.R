library(shiny)
library(fitbitScraper)
library(dplyr)
library(ggplot2)

source("fitdata.R")
source("fitdaily.R")
source("multiplot.R")

dat <- fitdata()

shinyServer(function(input, output) {
        
        output$activityControl <- renderUI({
                start <- input$date_range[1]
                if (as.Date(start) > as.Date("2015-03-17")){
                        radioButtons("activity", label=h3("Activity to Visualize"), choices=list("Steps"=1, "Distance"=2, "Very Active Minutes"=3, "Floors"=4, "Resting Heart Rate"=5), selected=1)
                } else if(as.Date(start) > as.Date("2012-01-01")) {
                        radioButtons("activity", label=h3("Activity to Visualize"), choices=list("Steps"=1, "Distance"=2, "Very Active Minutes"=3, "Floors" =4), selected=1)
                        
                } else {
                        radioButtons("activity", label=h3("Activity to Visualize"), choices=list("Steps"=1, "Distance"=2), selected=1)
                        
                }
        })
        
        output$map <- renderPlot({
                start <- input$date_range[1]
                end <- input$date_range[2]
                dat1 <- subset(dat, (time>=as.Date(start) & time<=as.Date(end)))
                
                if (input$activity ==1){
                        g1 <- ggplot(dat1, aes(time, steps)) + geom_line(col="red") + ggtitle("Daily Steps during Time-Frame") + labs(x="Date", y="Steps")
                } else if (input$activity == 2) {
                        g1 <- ggplot(dat1, aes(time, distance)) + geom_line(col="blue") + ggtitle("Daily Distance during Time-Frame") + labs(x="Date", y="Distance, miles")
                } else if (input$activity == 4){
                        g1 <- ggplot(dat1, aes(time, floors)) + geom_line(col="red") + ggtitle("Daily Floors climbed") + labs(x="Date", y="Floors climbed")
                } else if (input$activity == 3) {
                        g1 <- ggplot(dat1, aes(time, minutesVery)) + geom_line(col="blue") + ggtitle("Activity minutes per day") + labs(x="Date", y="Activity, minutes")
                } else {
                        g1 <- ggplot(dat1, aes(time, restingHeartRate)) + geom_line(col="red") + ggtitle("Resting Heart Rate") + labs(x="Date", y="Resting Heart-Rate, bpm")
                }

                g1 
               
                
        })
        
        output$text <- renderUI({
                start <- input$date_range[1]
                end <- input$date_range[2]
                dat1 <- subset(dat, (time>=as.Date(start) & time<=as.Date(end)))
                
                nzero <- filter(dat1, steps != 0)
                nzero1 <- group_by(nzero, weekday)
                
                sm <- summarize(nzero1, stp=mean(steps), active=mean(minutesVery))
                very <- filter(sm, active==max(sm$active))
                
                day <- filter(dat1, minutesVery==max(dat1$minutesVery))
                
                stpavg <- format(mean(nzero$steps), digits=2, nsmall=2)
                stpmedian <- median(nzero$steps)
                str <- paste("The total number of steps taken during this interval was ",sum(dat1$steps), " steps, and a total distance traveled of ", format(sum(dat1$distance), ndigits=2, nsmall=2), " miles. After eliminating the days where the fitbit tracker was not being used, the average number of steps during this time interval was ", stpavg, " steps, and the median number of steps was ",stpmedian, " steps. You were most active on ", very$weekday, "s with ", format(very$active, ndigits=2), " average minutes of activity on this day of the week during this interval.  Your most active day was ", day$weekday, " ", day$time, " with ", day$minutesVery, " minutes of activity, and ", day$steps, " step.", sep="")
                HTML(paste(str))
        })
        
        output$daily <- renderPlot({
                start <- input$date_range[1]
                end <- input$date_range[2]
                dat1 <- subset(dat, (time>=as.Date(start) & time<=as.Date(end)))
                high <- filter(dat1, minutesVery==max(dat1$minutesVery))
                highdate <- as.character(high$time)
                
                step2 <- fitdaily("steps", highdate)
                g1 <- ggplot(step2, aes(time, steps)) + geom_line(col="red") + ggtitle("Steps every 5 minutes during Most Active Day") + labs(x="Time", y="Steps")
               
                if (input$activity ==1){
                        g1
                } else if (input$activity == 2) {
                        dist2 <- fitdaily("distance", highdate)
                        g2 <- ggplot(dist2, aes(time, distance)) + geom_line(col="blue") + ggtitle("Distance Traveled at 5 minute Intervals of most Active Day") + labs(x="Date", y="Distance, miles")
                        multiplot(g1, g2, cols=2)
                } else if (input$activity == 3) {
                        act2 <- fitdaily("active-minutes", highdate)
                        colnames(act2) <- c("time", "act")
                        g2 <- ggplot(act2, aes(time, act)) + geom_line(col="blue") + ggtitle("Activity level throughout the most Active day") + labs(x="Date", y="Activity, minutes")
                        multiplot(g1, g2, cols=2)
                } else if (input$activity == 4) {
                        act2 <- fitdaily("floors", highdate)
                        g2 <- ggplot(act2, aes(time, floors)) + geom_line(col="red") + ggtitle("Floors climbed during the most Active day") + labs(x="Date", y="Activity, minutes")
                        multiplot(g1, g2, cols=2)
                } else {
                        hrt2 <- fitdaily("heart-rate", highdate)
                        g2 <- ggplot(hrt2, aes(time, bpm)) + geom_line(col="red") + ggtitle("Heart Rate during the Most Active Day") + labs(x="Time", y="Heart-Rate during the day, bpm")
                        multiplot(g1, g2, cols=2)
                }
        })
                
        output$doc <- renderUI({
                 str <- paste("This web-app scrapes data from fitbit.com and displays different parts of the data in the tabs in the mainPanel.  The Date-range is controlled through the slider control.  As the date-range changes, different data sets (activity level, floors, heart-rate) become available.  The data to view is selected with the radio buttions.  The data is summarized in text in the summary panel.  Here, the average daily step count, the time spent at high activity, the day-of-the-week with the, on-average, most activity is listed for the date-range selected.  This panel also finds the date with the highest activity level.  The Intraday panel displays the steps data at 5 minute intervals for the 24 hours of the most active day during the date-range selected.  If a radio button besides steps is selected, then the data for that parameter is also displayed.  This allows one to compare, these other parameters to the number of steps taken")
                 HTML(paste(str))
        })
        
})