fitdaily <- function(wht, dte){
        cookie <- login("maander6@gmail.com", "knen8175", rememberMe=FALSE)
        daily <- get_intraday_data(cookie, wht, dte)
        daily
}