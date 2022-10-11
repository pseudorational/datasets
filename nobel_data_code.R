library(jsonlite)
url = "http://api.nobelprize.org/v1/laureate.json"
library(dplyr)
library(tidyr)
df = fromJSON(url) %>%
  data.frame()%>%
  unnest(cols = laureates.prizes)%>%
  unnest(cols=affiliations)%>%
  select(-affiliations)%>%
  rename(number_sharing_award = share)
df2 = df

library(stringr)
colnames(df) = str_replace(colnames(df),pattern = 'laureates.',replacement = '')

df[is.na(df)] = '' # Replaced NA with blanks to make it usable for Tableau

write.csv(df, 'nobel.csv', row.names = F)  
