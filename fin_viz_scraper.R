
###########################Fin-Viz Scraper ##############################
#This code is meant to scrap some info from FinViz.com on a daily basis and add that info to datasets on my local device
library(rvest)
library(stringr)

fin_viz_scraper <- function(url){
  
  name<-str_split(url, regex('ta_'))
  
  
  out<-read_html(url) %>%
    html_nodes(xpath = '//tr[4]/td[1]/table[1]') %>%
    html_table(fill = TRUE)
  
  
  out2<-read_html(paste(url, '&r=21', sep = '')) %>%
    html_nodes(xpath = '//tr[4]/td[1]/table[1]') %>%
    html_table(fill = TRUE)
  
  
  new_df<-data.frame(out[2])
  new_df2<-data.frame(out2[2])
  
  
  colnames(new_df) <- new_df[1,]
  new_df <- new_df[-1,]
  new_df <- new_df[,-12]
  
  colnames(new_df2) <- new_df2[1,]
  new_df2 <- new_df2[-1,]
  new_df2 <- new_df2[,-12]
  
  
  output <- rbind(new_df, new_df2)
  
  
  
  #update the old csv here...
  
  old_data <- try(read.csv(paste("C:\\Users\\matth\\OneDrive\\Desktop\\StockData\\", name[[1]][2], '.csv', sep = '')), silent = TRUE)
  
  if(class(old_data) == 'try-error'){
    old_data <- data.frame()
    new_data <- rbind(old_data, output)
  } else {
    
    old_data <- old_data[,-1]
    colnames(old_data) <- colnames(output)
    
  }
  
  
  write.csv(new_data, paste("C:\\Users\\matth\\OneDrive\\Desktop\\StockData\\", name[[1]][2], '.csv', sep = ''))
}


#Scraping 40 most volatile stocks, top gainers, top losers, and unusual volume stocks for any given day...
fin_viz_scraper(url = "https://finviz.com/screener.ashx?v=111&s=ta_mostvolatile")
fin_viz_scraper(url = "https://finviz.com/screener.ashx?v=111&s=ta_topgainers")
fin_viz_scraper(url = "https://finviz.com/screener.ashx?v=111&s=ta_toplosers")
fin_viz_scraper(url = "https://finviz.com/screener.ashx?v=111&s=ta_unusualvolume")


##check the datasets for any repeats to account for days when the market is closed and the scraper still runs

