# Data Description
# health1: I am concerned about my health
# health2: I watch what I eat
# health3: I usually read ingredients on food labels
id = 1:2000
set.seed(617); health1 = sample(x = 1:7,size = 2000,replace = T)
set.seed(617); health2 = ceiling(health1 * runif(n = 2000)*runif(n=400))
set.seed(617); health3 = ceiling(health1*runif(n = 2000))

set.seed(617); mcdonalds = sample(1:7, size = 2000, replace=T,prob = c(0.2,0.2,0.2,0.1,0.1,0.1,0.1))
set.seed(1706); chipotle = sample(1:7, size = 2000, replace=T,prob = c(0.1,0.1,0.2,0.2,0.2,0.1,0.1))
set.seed(3110); shake_shack = sample(1:7, size = 2000, replace=T,prob = c(0.1,0.2,0.1,0.2,0.2,0.1,0.1))
# Gender: 'Male','Female'
set.seed(1031); gender = sample(x = c('Male','Female'),size = 2000,replace = T,prob = c(0.4,0.6))
# Age: '18-29','30-39','40-49','50-59','60+'
set.seed(61710); age = sample(x = c('18-29','30-39','40-49','50-59','60 or over'),size = 2000,replace = T,prob = c(0.2,0.33,0.3,0.15,0.02))
# Marital status
set.seed(103110)
marital_status = sample(c('married','widowed','divorced','separated','never married'),size = 2000,T, prob = c(0.4, 0.01, 0.03, 0.06, 0.50))
# Location: 'Manhattan', 'Brooklyn', 'Queens', 'New Jersey'
set.seed(1731); location = sample(x = c('Manhattan','Brooklyn','Queens','New Jersey'),size = 2000,replace = T, prob = c(0.5, 0.2, 0.2, 0.1))
df = data.frame(id, health1, health2, health3, mcdonalds, chipotle, shake_shack, gender, age, marital_status, location)

# Create Rank columns for the restaurants
temp = df[,c('id', 'mcdonalds', 'chipotle','shake_shack')]
library(tidyr); library(dplyr)
temp = 
  temp %>%
  gather(key='restaurant', value='rating',2:4)%>%
  group_by(id)%>%
  mutate(rank = rank(rating, ties.method = 'first',))%>%
  ungroup()%>%
  select(id, restaurant, rank)%>%
  spread(restaurant, rank)
names(temp) = c('id', 'rank_chipotle','rank_mcdonalds','rank_shake_shack')
df = cbind(df,temp[,2:4])
#head(df)
write.csv(x = df, file = 'fastfood.csv', row.names = F)