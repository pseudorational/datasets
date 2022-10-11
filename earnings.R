# Earnings Data
# 
# Earning data is derived from a survey of individuals on a multitude of characteristics including demographics, physical characteristics, health, well-being and earning. (Original Data Source: Regression and Other stories, by Andrew Gelman, Jennifer Hill, and Avi Vekhtari). We are interested in examining the factors that influence annual earning (`earn`) and predicting an individuals annual earning. 
# 
# Data consists of characteristics of a set of employees and their annual earning. Variables included are: 
#   
# * earn: Annual earning in dollars  
# * age: Age in years  
# * gender: male, female  
# * age: Height in inches  
# * weight: Weight in pounds  
# * ethnicity: White, African American, Hispanic, Asian  
# * education: Years of education  
# * walk: Frequency of taking a walk (in a week)
# * exercise: Frequency of strenuous exercise (in a week)
# * smokenow: Smoke 7 or more cigarettes a week (1 = Yes, 2 = No)
# * tense: Days felt tense or anxious

earnings = read.csv('https://raw.githubusercontent.com/avehtari/ROS-Examples/master/Earnings/data/earnings.csv')
library(dplyr)
tapply(X = earnings$earn,INDEX = earnings$ethnicity, 'mean')
earning =
  earnings %>%
  select(-mother_education, -father_education, -angry) %>%
  filter(!is.na(weight), !is.na(education), !is.na(smokenow), !is.na(tense))%>%
  mutate(earn = round(earn*2.33,0)) %>%      # inflation adjustment based on CPI https://www.bls.gov/data/inflation_calculator.htm
  dplyr::select(-earnk) %>%
  dplyr::select(earn, age, gender = male, height, everything())%>%
  mutate(gender = ifelse(gender == 1,'male','female')) %>%
  mutate(ethnicity = forcats::fct_recode(.f = ethnicity,'Asian' = 'Other', 'African American' ='Black' ))
write.csv(x = earning, file = 'earning.csv',row.names = F)
#apply(X = earning,MARGIN = 2,FUN = function(x) sum(is.na(x)))

