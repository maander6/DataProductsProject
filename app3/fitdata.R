fitdata <- function(){
        library(dplyr)
        library(fitbitScraper)
        
        cookie <- login("maander6@gmail.com", "knen8175", rememberMe=FALSE)
        
        start <- "2010-01-20"
        steps <- get_daily_data(cookie, "steps", start, as.character(Sys.Date()))
        dist <- get_daily_data(cookie, "distance", start, as.character(Sys.Date()))
        floors <- get_daily_data(cookie, "floors", start, as.character(Sys.Date()))
        active <- get_daily_data(cookie, "minutesVery", start, as.character(Sys.Date()))
        heart <- get_daily_data(cookie, "getRestingHeartRateData", start, as.character(Sys.Date()))
        
        dat <- merge(steps, dist, all.x=TRUE)
        dat <- merge(dat, floors, all.x=TRUE)
        dat <- merge(dat, active, all.x=TRUE)
        dat <- merge(dat, heart, all.x=TRUE)
        
        dat$time <- as.Date(dat$time)
        dat$weekday <- weekdays(dat$time)
        
        dat
        
}