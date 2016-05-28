fitdaily <- function(wht, dte){
        
        # Hide the login information for public display on github
        
        cookie <- login(email="****************", password="*****************", rememberMe=FALSE)
        daily <- get_intraday_data(cookie, wht, dte)
        daily
}