# Fields

library(rvest)
page = read_html('https://en.wikipedia.org/wiki/Fields_Medal#Fields_medalists')
temp = 
  page %>%
  html_table()
temp[[2]]
write.csv(temp[[2]],'fields.csv',row.names = F)