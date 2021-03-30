## Yellow Cab Data
# Data Source: https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page

library(dplyr); library(readr); library(lubridate)
dat = 
  read.csv('https://nyc-tlc.s3.amazonaws.com/trip+data/yellow_tripdata_2020-12.csv')%>%
  mutate_at(.vars = c('tpep_pickup_datetime','tpep_dropoff_datetime'),
            .funs = function(x) ymd_hms(x, tz = 'US/Eastern'))%>%
  mutate(trip_duration = round(as.integer(as.period(interval(tpep_pickup_datetime,tpep_dropoff_datetime),unit = 'seconds'))/60,1)) %>%
  mutate(pickup_period = cut(hour(tpep_pickup_datetime),
                             breaks = c(0,6,12,16,22,24),
                             labels = c('night','morning','afternoon','evening','night'),
                             right = F))%>%
  filter(payment_type==1)%>%
  mutate(tip = factor(as.integer(tip_amount>0),
                      levels = c(0,1),
                      labels = c('No Tip','Tip')))%>%
  mutate(trip_id = 1:length(tip_amount))%>%
  select(trip_id, tpep_pickup_datetime,tpep_dropoff_datetime,trip_duration,trip_distance,passenger_count,fare_amount,tolls_amount,tip_amount, tip)

dat_small = dat[sample(1:nrow(dat),size = 0.1*nrow(dat)),]
write.csv(x = dat,'taxi_tip_dec.csv',row.names = F)
#write.csv(x=dat_small,'mini_taxi_tip.csv',row.names = F)


dat_tip = dat[sample(1:nrow(dat[dat$tip=='Tip',]),size = 4*nrow(dat[dat$tip=='No Tip',])),]
dat_no_tip = dat[dat$tip== 'No Tip',]
dat_oversampled = rbind(dat_tip, dat_no_tip)
nrow(dat_oversampled)
prop.table(table(dat_oversampled$tip))
write.csv(x = dat_oversampled,file = 'taxi_tip.csv')