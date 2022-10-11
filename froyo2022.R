#############################
# Satisfaction Study

# Satisfaction measures for Red Mango and 16 handles
# gender
# Rewards Card (16 Handles)
# Importance of quality, variety, price, distance, atmosphere, courteousness of staff
# Rank order above variables
# Social media platform "used the most" "most used"

id = 1:5000
set.seed(10311); quality = sample(x = 1:5,size = 5000,replace = T,prob = c(0.1,0.15,0.2,0.25,0.3))
set.seed(10311); variety = sample(x = 1:5,size = 5000,replace = T,prob = c(0.1,0.15,0.25,0.25,0.2))
set.seed(10311); price = sample(x = 1:5,size = 5000,replace = T,prob = c(0.1,0.15,0.3,0.25,0.2))
set.seed(10311); distance = sample(x = 1:5,size = 5000,replace = T,prob = c(0.1,0.25,0.1,0.25,0.3))
set.seed(10313); atmosphere = sample(x = 1:5,size = 5000,replace = T,prob = c(0.1,0.2,0.2,0.2,0.3))
set.seed(10313); courteousness = sample(x = 1:5,size = 5000,replace = T,prob = c(0.15,0.2,0.2,0.2,0.25))

set.seed(1031); rating_PinkBerry =   sample(1:5, size = 5000, replace=T,prob = c(0.2,0.3,0.2,0.2,0.1))
set.seed(1031); rating_RedMango =  sample(1:5, size = 5000, replace=T,prob = c(0.1,0.1,0.2,0.2,0.4))
set.seed(1031); rating_16Handles = sample(1:5, size = 5000, replace=T,prob = c(0.1,0.1,0.2,0.25,0.35))
# 1 is No, 2 is Yes; 3 is Don't know.
set.seed(103111); rewardsCard_16Handles = sample(x = c(1,2,3),size = 5000,replace = T,prob = c(0.59,0.4,0.01))
# 1: 'Snapchat', 2: 'Instagram', 3: 'Facebook', 4: 'Twitter', 5: 'None of these'
set.seed(1731); social = sample(x = c(1, 2, 3, 4, 5),
                                size = 5000,replace = T, prob = c(0.3, 0.4, 0.15, 0.1, 0.05))
# 1 is Male, 2 is Female
set.seed(617); gender = sample(x = c(1, 2),size = 5000,replace = T,prob = c(0.2,0.8))

df = data.frame(id, quality, variety, price, distance, courteousness,atmosphere, rating_PinkBerry, rating_RedMango, rating_16Handles, rewardsCard_16Handles, social, gender)


# Create Rank columns for the restaurants
temp = df[,c('id', 'rating_PinkBerry', 'rating_RedMango','rating_16Handles')]
library(tidyr); library(dplyr)
temp = 
  temp %>%
  gather(key='froyo', value='rating',2:4)%>%
  group_by(id)%>%
  mutate(rank = rank(rating, ties.method = 'first'))%>%
  ungroup()%>%
  select(id, froyo, rank)%>%
  spread(froyo, rank)
names(temp) = c('id', 'rank_PinkBerry','rank_RedMango','rank_16Handles')
df = cbind(df,temp[,2:4])
df = df[,c(1:10,14:16,11:13)]

#write.csv(df, file = 'froyo.csv',row.names = F)

df$rewardsCard_16Handles = as.integer(df$rewardsCard_16Handles)
df$social = as.integer(df$social)
df$gender = as.integer(df$gender)

write.csv(x = df, file = 'froyo.csv', row.names = F)