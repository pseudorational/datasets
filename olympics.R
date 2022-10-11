olympics <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-07-27/olympics.csv')
write.csv(x = olympics,file = 'olympics.csv', row.names = F)


olympics_swimming = olympics[olympics$year>=1960 & olympics$sport=='Swimming' ,]
olympics_swimming$medalist = ifelse(is.na(olympics_swimming$medal),'No','Yes')
olympics_swimming$medal[is.na(olympics_swimming$medal)] = 'None'
write.csv(x = olympics_swimming,file = 'olympics_swimming.csv', row.names = F)

# Data Description

# head(olympics_swimming)
# id: Unique Identifier
# name: Name of swimmer
# sex: M or F
# age: age in years
# height: height in cm
# weight: weight in kg
# team: team represented
# noc: name of country
# games: Olympic event
# year: Year
# season: Summer. Winter data removed.
# city: City host of the event
# sport: Swimming. Other sports removed. 
# event: Swimming event 
# medal: Gold, Silver, Bronze or None. Non-medalists are labeled as None. 
# medalist: Yes or No indicating whether they received a medal or not. 

