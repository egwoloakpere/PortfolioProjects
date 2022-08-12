install.packages("Tidyverse")
install.packages("lubridate")
install.packages("ggplot2")
install.packages("dplyr")
install.packages("skimr")
install.packages("readr")
install.packages("janitor")


library(tidyverse)
library(lubridate)
library(ggplot2)
library(dplyr)
library(skimr)
library(readr)
library(janitor)


getwd()
setwd("C:/Users/HP PC/Documents")

Jan <- read.csv("Tripdata_2021_Aug_13th_11_16_49_Pm.csv")
Feb <- read.csv("Tripdata_2021_Dec_8th_12_19_04_Pm.csv")
Mar <- read.csv("Tripdata_2021_Nov_4th_12_58_36_Pm.csv")
Apr <- read.csv("Tripdata_2021_Oct_4th_10_21_39_Am.csv")
May <- read.csv("Tripdata_2021_Sep_8th_11_10_46_Am.csv")
Jun <- read.csv("Tripdata_2022_Apr_6th_10_07_41_Am.csv")
Jul <- read.csv("Tripdata_2022_Feb_2nd_08_55_22_Am.csv")
Aug <- read.csv("Tripdata_2022_Jan_6th_08_18_45_Am.csv")
Sep <- read.csv("Tripdata_2022_Jul_15th_08_27_59_Am.csv")
Oct <- read.csv("Tripdata_2022_Jun_3rd_07_08_02_Pm.csv")
Nov <- read.csv("Tripdata_2022_May_2nd_12_22_47_Pm.csv")
Dec <- read.csv("Tripdata_2022_May_3rd_09_33_19_Am.csv")


colnames(Jan)
colnames(Feb)
colnames(Mar)
colnames(Apr)
colnames(May)
colnames(Jun)
colnames(Jul)
colnames(Aug)
colnames(Sep)
colnames(Oct)
colnames(Nov)
colnames(Dec)


View(Jan)
View(Feb)
View(Mar)
View(Apr)
View(May)
View(Jun)
View(Jul)
View(Aug)
View(Sep)
View(Oct)
View(Nov)
View(Dec)


General_tripdata <- rbind(Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
colnames(General_tripdata)
nrow(General_tripdata)
ncol(General_tripdata)
table(General_tripdata)
dim(General_tripdata)
head(General_tripdata)
tail(General_tripdata)
str(General_tripdata)
glimpse(General_tripdata)
summary(General_tripdata)
skim_without_charts(General_tripdata)

nrow(distinct(General_tripdata)) == nrow(General_tripdata)


sum(is.na(General_tripdata))
General_tripdata <- na.omit(General_tripdata)
sum(is.na(General_tripdata))


General_tripdata <- General_tripdata %>% 
  rename(bike_id = "ride_id") %>%
  rename(bike_type = "rideable_type") %>% 
  rename(user_type = "member_casual") %>%
  rename(start_time = "started_at") %>% 
  rename(end_time = "ended_at")


View(General_tripdata)


General_tripdata$date <- as.Date(General_tripdata$start_time)
General_tripdata$month <- format(General_tripdata$date, "%m")
General_tripdata$day <- format(General_tripdata$date, "%d")
General_tripdata$year <- format(General_tripdata$date, "%Y")
General_tripdata$day_of_week <- format(General_tripdata$date, "%A")

General_tripdata$day_of_week <- factor(General_tripdata$day_of_week, levels = c
                                       ("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday",
                                         "Friday", "Saturday"))

General_tripdata$ride_length <- difftime(General_tripdata$end_time,
                                         General_tripdata$start_time, units = "mins")


is.factor(General_tripdata$ride_length)
General_tripdata$ride_length <- as.numeric(as.character(General_tripdata$ride_length))
is.numeric(General_tripdata$ride_length)

table(General_tripdata$ride_length<=0)
select(General_tripdata, ride_length, end_time, start_time, start_station_name) %>%
  filter(ride_length <= 0)

updated_tripdata <- General_tripdata[!(General_tripdata$start_station_name
                                       == "HQ QR" | General_tripdata$ride_length<=0),]

table(updated_tripdata$ride_length<=0)  
View(updated_tripdata)


summary_ride_length <- updated_tripdata %>% 
  summarise(min_ride_length = min(ride_length), max_ride_length = max(ride_length),
            mean_ride_length = mean(ride_length), units= "mins")
View(summary_ride_length)  


Percent_dist <- updated_tripdata %>% 
  group_by(user_type)%>%
  summarise(n=n())%>%
  mutate(percent = n*100/sum(n))
View(Percent_dist)

ggplot(data=Percent_dist, aes(x=user_type, y= percent, fill = user_type)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"))+
  labs(title="Percentage Ride Distribution")

rides_per_length<-updated_tripdata %>% 
  group_by(user_type) %>%
  summarise(number_of_ride = n(), avg_ride_length = mean(ride_length), .groups = "drop")
View(rides_per_length)

ggplot(data=rides_per_year, aes(x=user_type, y=avg_ride_length, fill = user_type)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"))+
  labs(title="Average Ride Length Vs users")

rides_per_year<-updated_tripdata %>% 
  group_by(user_type, year) %>%
  summarise(number_of_ride = n(), avg_ride_length = mean(ride_length), .groups = "drop")
View(rides_per_year)

ggplot(data=rides_per_year, aes(x=year, y= number_of_ride, fill = user_type)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"))+
  labs(title="Number of Rides Per Year")


rides_per_month<-updated_tripdata %>% 
  group_by(user_type, month) %>%
  summarise(number_of_ride = n(), avg_ride_length = mean(ride_length), .groups = "drop")
View(rides_per_month)

ggplot(data=rides_per_month, aes(x=month, y= number_of_ride, fill = user_type)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"))+
  labs(title="Number of Rides Per Month")


rides_per_day<-updated_tripdata %>% 
  group_by(user_type, day_of_week) %>%
  summarise(number_of_ride = n(), avg_ride_length = mean(ride_length), .groups = "drop")
View(rides_per_day)

ggplot(data=rides_per_day, aes(x=day_of_week, y= number_of_ride, fill = user_type)) +
  geom_col(position = "dodge") +
  scale_fill_manual(values = c("blue", "red"))+
  labs(title="Number of Rides Per Day")


most_used_bike<-updated_tripdata %>%  
  group_by(bike_type) %>%
  summarise(number_of_ride = n(), avg_ride_length = mean(ride_length), .groups = "drop")
View(most_used_bike)

ggplot(data=most_used_bike, aes(x=bike_type, y= number_of_ride, fill = bike_type)) +
  geom_col(position = "dodge")+
  scale_fill_manual(values = c("blue", "red", "Green"))+
  labs(title="Most Used Bike")


most_used_user_bike<-updated_tripdata %>% 
  group_by(user_type, bike_type) %>%
  summarise(number_of_ride = n(), avg_ride_length = mean(ride_length), .groups = "drop")
View(most_used_user_bike)
  
  
ggplot(data=most_used_user_bike, aes(x=bike_type, y= number_of_ride, fill = user_type)) +
  geom_col(position = "dodge")+
  scale_fill_manual(values = c("blue", "red"))+
  labs(title="Most Used Bike By Users")


casual_start_station<-updated_tripdata %>% 
  group_by(user_type, start_station_name) %>%
  filter(user_type == "casual") %>% 
  summarise(number_of_ride = n(), .groups = "drop") %>% 
  arrange(desc(number_of_ride)) %>% 
  head(20) 
View(casual_start_station)

ggplot(data=casual_start_station,aes(x=user_type, y= start_station_name, fill = user_type)) +
  geom_col(position = "dodge")+
  scale_fill_manual(values = c("blue"))+
  labs(title="Top 20 Most Popular Start Station By Casual Users")

member_start_station<-updated_tripdata %>% 
  group_by(user_type, start_station_name) %>%
  filter(user_type == "member") %>% 
  summarise(number_of_ride = n(), .groups = "drop") %>%
  arrange(desc(number_of_ride)) %>% 
  head(20)
View(member_start_station)

ggplot(data=member_start_station, aes(x=user_type, y= start_station_name, fill = user_type,)) +
  geom_col(position = "dodge")+ 
  scale_fill_manual(values = c("red"))+
  labs(title="Top 20 Most Popular Start Station By Member Users")


casual_end_station<-updated_tripdata %>%  
  group_by(user_type, end_station_name) %>%
  filter(user_type == "casual") %>% 
  summarise(number_of_ride = n(), .groups = "drop") %>% 
  arrange(desc(number_of_ride)) %>% 
  head(20) 
View(casual_end_station)

ggplot(data=casual_end_station, aes(x=user_type, y= end_station_name, fill = user_type)) +
  geom_col(position = "dodge")+
  scale_fill_manual(values = c("blue"))+
  labs(title="Top 20 Most Popular End Station By Casual Users")


member_end_station<- updated_tripdata %>% 
  group_by(user_type, end_station_name) %>%
  filter(user_type == "member") %>% 
  summarise(number_of_ride = n(), .groups = "drop") %>% 
  arrange(desc(number_of_ride)) %>% 
  head(20)
View(member_end_station)

ggplot(data=member_end_station, aes(x=user_type, y= end_station_name, fill = user_type,)) +
  geom_col(position = "dodge")+ 
  scale_fill_manual(values = c("red"))+
  labs(title="Top 20 Most Popular End Station By Member Users")

export_citybike<-updated_tripdata %>% 
  select(ride_length, user_type, day_of_week)
View(export_citybike)

write.csv(export_citybike,"CityBikeProject.csv")



