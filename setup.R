packrat::snapshot()
install.packages("shiny")
install.packages("shinydashboard")
packrat::status()
packrat::restore()
proj_setup <- xfun::session_info() 
install.packages("dygraphs")
rsconnect::setAccountInfo(name='aziizsut',
                          token='A087BAD6BCBA7EB822DF9E591E8A1CB7',
                          secret='3e3Sn2cBGS3ayRthf0lUVm9AUHsl1d4JrnXf0sxS')
install.packages("tidyverts")
fpp2::elecdaily
ldeaths
class(ldeaths)
fpp2::elecdemand
testo <- fpp2::elecdemand[1:nrow(fpp2::elecdemand)]
myts <- ts(testo, frequency=48)
class(myts)
myts


lim1 <- 200
lim2 <- 300
base <- 0

daset <- data.frame(rbind(base,lim1,lim2)) %>% 
  rename(hasil = colnames(.)[1])

ggplot(daset, aes(y = hasil))
