# Download Movie100K file from GroupLens site
download.file('http://files.grouplens.org/datasets/movielens/ml-100k.zip', destfile='ml-100k.zip')
unzip('ml-100k.zip',exdir='movielens')
#dir('movielens/ml-100k/')
ratings = read.table('movielens/ml-100k/u.data', 
                     header = F, 
                     sep = '\t',
                     col.names = c('userId', 'movieId', 'rating', 'timestamp'))
head(ratings)
library(dplyr); library(tidyr); library(janitor); library(tibble)
ratings[,1:3]
as(ratings[,1:3], 'realRatingMatrix')

#pivot_wider(ratings, names_from = movieId, values_from = rating)

ratings_mat = 
  ratings %>%
  select(userId, movieId, rating)%>%
  pivot_wider(names_from = movieId, values_from = rating)%>%
  rename_with(.cols = !contains('userId'),.fn = function(x) paste0('movie',x))%>%
  mutate(userId  = paste0('user',userId))
ratings_mat = as.data.frame(ratings_mat)
rownames(ratings_mat) = ratings_mat$userId
ratings_mat$userId = NULL
ratings_mat = as.matrix(ratings_mat)
ratings_mat[1:5, 1:5]


library(recommenderlab)
saveRDS(object = as(ratings_mat, 'realRatingMatrix'),file = 'movies.rds')

