library(quantmod)
library(tidyquant)
library(tidyverse)
library(xlsx)


df <- read.delim("tickerdata.txt")


df<-str_split_fixed(df$Symbol.Security.Name.Market.Category.Test.Issue.Financial.Status.Round.Lot.Size.ETF.NextShares, "\\|", 3)

df<-df[,-3]

df<-data.frame(df)

df <- rename(df, ticker = "X1")

df <- rename(df, company = "X2")

df$exchange <- c("nasdaq")

####now doing other exchanges' tickers....

df2 <- read.delim("othertickers.txt")

df2<-str_split_fixed(df2$ACT.Symbol.Security.Name.Exchange.CQS.Symbol.ETF.Round.Lot.Size.Test.Issue.NASDAQ.Symbol, "\\|", 3)

df2 <- df2[,-3]

df2<-data.frame(df2)

df2 <- rename(df2, ticker = "X1")

df2 <- rename(df2, company = "X2")

df2$exchange <- c("other")


##May use this for some shiny app or a tool for analysis ##
stock_data <- rbind(df,df2)


rm(list=setdiff(ls(), "stock_data"))





###############Messing around with some Charts ###############################
getSymbols("AAPL", from = '2017-01-01',
           to = "2020-12-15",warnings = FALSE,
           auto.assign = TRUE)


tail(AAPL)

chart_Series(AAPL)
addVo()


chart_Series(BCDA['2020-03/2020-15'])

lineChart(AAPL, line.type = 'h', theme = 'white')

getSymbols('SBUX')
barChart(SBUX)
addTA(EMA(Cl(SBUX)), on=1, col=6)
addTA(OpCl(SBUX), col=4, type='b', lwd=2)

head(Cl(SBUX))


