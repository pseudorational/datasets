## Yellow Cab Data
# This data contains NYC taxi trip data for April 2022. Original data gathered from 
# NYC Taxi & Limousine Commission (https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page)
# was cleaned, filtered and new features created. 

# Data Description  
# 
# * trip_id: Unique identifier for each trip  
# * trip_duration: Duration of trip in minutes  
# * trip_distance: Distance of trip in miles  
# * passenger_count: Number of passengers  
# * fare_amount: Fare calculated by the meter. This does not include tolls, surcharges or tips  
# * tolls_amount: Amount of all tolls paid in trip   
# * tip: whether the taxi driver received a Tip or No Tip  
# * tip_amount: tip paid  
# * period_of_day: Time of day for pickup: morning, afternoon, evening, night  
# * pickup_date: Date of month for pickup  
# * period_of_month: Period of month when the trip occurred: beginning, middle, end  
# * pickup_day: Day of week for trip: Mon, Tue, Wed, Thu, Fri, Sat, Sun  
# * pickup_hour: Hour of day for pickup  
# * pickup_min: Minute of day for pickup  
# * pickup_sec: Second of day for pickup  
# * pickup_time: Pick up date and time  
# * dropoff_time: Drop off date and time  

# Data Source: https://www1.nyc.gov/site/tlc/about/tlc-trip-record-data.page
# Data is for April 2022
# Data is now shared in a columnar format. File was manually downloaded and then parsed using arrow::read_parquet()

library(arrow);library(dplyr); library(readr); library(lubridate)
dat = 
  read_parquet(file = 'c:/myfiles/learning/datasets/yellow_tripdata_2022-04.parquet',as_data_frame = T) %>%
  filter(RatecodeID==1)%>%
  filter(store_and_fwd_flag=='N') %>%
  filter(payment_type==1)%>%
  mutate_at(.vars = c('tpep_pickup_datetime','tpep_dropoff_datetime'),
            .funs = function(x) ymd_hms(x, tz = 'US/Eastern'))%>%
  mutate(trip_duration = round(as.integer(as.period(interval(tpep_pickup_datetime,tpep_dropoff_datetime),unit = 'seconds'))/60,1)) %>%
  mutate(period_of_day = cut(hour(tpep_pickup_datetime),
                             breaks = c(0,6,12,16,22,24),
                             labels = c('night','morning','afternoon','evening','night'),
                             right = F))%>%
  mutate(pickup_date = lubridate::day(tpep_pickup_datetime))%>%
  filter(pickup_date<31)%>%
  mutate(period_of_month = cut(pickup_date,
                                      breaks = c(1,10,20,31),
                                      labels = c('beginning','middle','end'),
                                      right = F) )%>%
  mutate(pickup_day = lubridate::wday(tpep_pickup_datetime,label = T)) %>%
  mutate(pickup_hour = lubridate::hour(tpep_pickup_datetime)) %>%
  mutate(pickup_min = lubridate::minute(tpep_pickup_datetime)) %>%
  mutate(pickup_sec = lubridate::second(tpep_pickup_datetime)) %>%
  mutate(tip = factor(as.integer(tip_amount>0),
                      levels = c(0,1),
                      labels = c('No Tip','Tip')))%>%
  mutate(trip_id = 1:length(tip_amount))%>%
  rename(pickup_time = tpep_pickup_datetime, dropoff_time = tpep_dropoff_datetime) %>%
  select(trip_id, trip_duration, trip_distance, passenger_count, fare_amount, tolls_amount, tip, tip_amount, 
         period_of_day,pickup_date, period_of_month, pickup_day, pickup_hour, pickup_min, pickup_sec, pickup_time, dropoff_time)

# table(cut(dat$trip_duration,breaks = seq(0,1440,60),labels = 1:24)) # 99.85% rides are less than 2 hours
# sum(dat$fare_amount<=0) # 253 rides with a far less than or equal to 0
# sum(dat$tip_amount<0) # 4 rides had a tip less than 0
# sum(trip_distance==0)      #  7633 trips of 0 miles
# table(cut(dat$tolls_amount,breaks = seq(0,550,10)))

dat = 
  dat %>%
  filter(!dat$fare_amount<=0)|>  # remove 253 rows with fare_amount equal to 0 or negative
  filter(!tip_amount<0)|>        # filter 4 rows with negative tip
  filter(!trip_duration>120)|>    # filter 3371 rows with trips longer than 2 hours
  filter(!trip_distance<=0)|>     # 7633 trips of 0 miles
  filter(!tolls_amount>30)      # 26 trips with tolls greater than $30

set.seed(617)
taxi = dat[sample(x = 1:nrow(dat),size = 0.01*nrow(dat)),]

write.csv(x = taxi, file = 'c:/myfiles/learning/datasets/taxi.csv',row.names = F)
rm(taxi)


# Oversampled Taxi
data =
  dat %>%
  filter(tip_amount == 0 | tip_amount >= 4)%>%
  select(-tip) %>%
  mutate(tip = as.integer(tip_amount>0))%>%
  select(-tip_amount)%>%
  select(trip_id, tip, everything())

data_tip = data[data$tip==1,]
data_no_tip = data[data$tip == 0, ]
set.seed(1031)
data_tip = data_tip[sample(x = 1:nrow(data_tip),size = 1 * nrow(data_no_tip)), ]
data = rbind(data_tip, data_no_tip)
data = data %>%
  arrange(trip_id)
set.seed(1031)
taxi_class = data[sample(x = 1:nrow(data),size = 0.1*nrow(data)),]



# taxi_class%>%
#   group_by(pickup_date)%>%
#   summarize(mean(tip))%>%
#   ungroup()%>%
#   data.frame()%>%
#   head(30)



write.csv(x = taxi_class, file = 'c:/myfiles/learning/datasets/taxi_class.csv',row.names = F)
rm(dat); rm(data); rm(taxi_class)


############################################## END #################################

library(ggplot2); library(tidyr)

ggplot(dat, aes(x='', y = trip_duration))+
  geom_boxplot(outlier.color = 'red')
View(dat[dat$trip_distance>50,])

write.csv(x = dat,'taxi_tip_full_july_2021.csv',row.names = F)

set.seed(617)
dat_small = dat[sample(1:nrow(dat),size = 0.1*nrow(dat)),]
write.csv(x = dat_small,'taxi_tip_sample_july_2021.csv',row.names = F)

set.seed(617)
dat_tip = dat[sample(1:nrow(dat[dat$tip=='Tip',]),size = 4*nrow(dat[dat$tip=='No Tip',])),]
dat_no_tip = dat[dat$tip== 'No Tip',]
dat_oversampled = rbind(dat_tip, dat_no_tip)
dat_oversampled = dat_oversampled[order(dat_oversampled$trip_id),]

nrow(dat_oversampled)
prop.table(table(dat_oversampled$tip))
write.csv(x = dat_oversampled,file = 'taxi_tip_july_2021_oversampled.csv', row.names=F)
library(haven)
write_sav(data = dat_oversampled,path = 'taxi_tip_july_2021_oversampled.sav') 


#############
