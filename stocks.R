# Stocks
library(quantmod)
stockSymbols = c('FB','AAPL','MSFT','GOOG','AMZN')
getSymbols(Symbols = stockSymbols)
library(xts)
stocks = merge.xts(FB,AAPL,MSFT,GOOG,AMZN)
stocks = stocks['2013/2019']
stocks = stocks[,c('FB.Close','AAPL.Close','MSFT.Close','GOOG.Close','AMZN.Close')]
names(stocks) = c('FB','AAPL','MSFT','GOOG','AMZN')
stocks %>%
  data.frame(date = index(stocks))%>%
  select(date,everything())%>%
  write.csv('stocks.csv',row.names = F)