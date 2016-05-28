fitdaily <- function(wht, dte){
        
        ##  Hide the username and password for security in the github posting
        
        cookie <- login(username="*************", password="*************", rememberMe=FALSE)
        daily <- get_intraday_data(cookie, wht, dte)
        daily
}