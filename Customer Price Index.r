library(quantmod)
setSymbolLookup(CPIAUCSL='FRED')
getSymbols("CPIAUCSL", src = "FRED")
setSymbolLookup(CUUR0000SA0R='FRED')
getSymbols("CUUR0000SA0R", src = "FRED")
library(dygraphs)
xx<-cbind(CPIAUCSL-100,CUUR0000SA0R)
dygraph(xx, main ="Consumer Price Index (blue) / Purchase Power (green)- USA") %>% 
  dyOptions(
          dygraph,axisLineWidth = 1.5, fillGraph = TRUE, 
          colors=c("blue","green"),pointSize=2,
          animatedZooms=T) %>% dyRangeSelector(
            dateWindow = c("1977-01-01", "2016-05-01"))