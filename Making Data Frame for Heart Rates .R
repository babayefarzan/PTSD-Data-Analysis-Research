#### In this code I am making a big data frame that has all stress moments for everyone and 
#and heart rate at the moment
#and activity and time of the day
#I wanna see the distribution of heart rate in these moments and affect of day/night in it



ls()
rm(list=ls())
#read Data

###########################################DC################################DC################


fileNames <- Sys.glob("Desktop/PTSD/PTSD Data/DC Data/DC-20181010T215944Z-001/DC/*.csv")
i<- 1

p<- list.files("Desktop/PTSD/PTSD Data/DC Data/DC-20181010T215944Z-001/DC", pattern="*.csv", full.names=TRUE)
A <- "DC"
total <- data.frame()
for (i in 1:21) {
  #reading in data
  data <- read.csv (filename <- p[[i]])
  ndata <- data [!is.na(data$ptsd_moment),]
  #ndata <- ndata[!ndata$hr==0,]
  if (nrow(ndata)==0) {next}
  #put all the data in the datframe
  ndata$i = i
  ndata$zone=A
  total<- rbind (total,ndata)
}



#############GL############
fileNames <- Sys.glob("Desktop/PTSD/PTSD Data/GL Data/GL/*.csv")
i<- 1

p<- list.files("Desktop/PTSD/PTSD Data/GL Data/GL", pattern="*.csv", full.names=TRUE)
A <- "GL"
#totalDC <- data.frame()
for (i in 1:12) {
  #reading in data
  data <- read.csv (filename <- p[[i]])
  ndata <- data [!is.na(data$ptsd_moment),]
  #ndata <- ndata[!ndata$hr==0,]
  if (nrow(ndata)==0) {next}
  #put all the data in the datframe
  ndata$i = i
  ndata$zone=A
  total<- rbind (total,ndata)
}


##############################CALIFORNIA######################################################################

fileNames <- Sys.glob("Desktop/PTSD/PTSD Data/California/drive-download-20181204T172324Z-001/*.csv")
i<- 1

p<- list.files("Desktop/PTSD/PTSD Data/California/drive-download-20181204T172324Z-001", pattern="*.csv", full.names=TRUE)
A <- "CALI"
#totalDC <- data.frame()
for (i in 1:21) {
  #reading in data
  data <- read.csv (filename <- p[[i]])
  ndata <- data [!is.na(data$ptsd_moment),]
  #ndata <- ndata[!ndata$hr==0,]
  if (nrow(ndata)==0) {next}
  #put all the data in the datframe
  ndata$i = i
  ndata$zone=A
  total<- rbind (total,ndata)
}


##############################LASVEGAS#############################################################

fileNames <- Sys.glob("Desktop/PTSD/PTSD Data/LasVegas/drive-download-20181204T171643Z-001/*.csv")
i<- 1

p<- list.files("Desktop/PTSD/PTSD Data/LasVegas/drive-download-20181204T171643Z-001", pattern="*.csv", full.names=TRUE)
A <- "LASVEGAS"
for (i in 1:8) {
  #reading in data
  data <- read.csv (filename <- p[[i]])
  ndata <- data [!is.na(data$ptsd_moment),]
  #ndata <- ndata[!ndata$hr==0,]
  if (nrow(ndata)==0) {next}
  #put all the data in the datframe
  ndata$i = i
  ndata$zone=A
  total <- rbind (total,ndata)
}


##############################SANANTONIO2############################################################

fileNames <- Sys.glob("Desktop/PTSD/PTSD Data/San Antonio 2/SA2/*.csv")
i<- 1

p<- list.files("Desktop/PTSD/PTSD Data/San Antonio 2/SA2", pattern="*.csv", full.names=TRUE)
A <- "SANANTONIO"
for (i in 1:36) {
  #reading in data
  data <- read.csv (filename <- p[[i]])
  ndata <- data [!is.na(data$ptsd_moment),]
  #ndata <- ndata[!ndata$hr==0,]
  if (nrow(ndata)==0) {next}
  #put all the data in the datframe
  ndata$i = i
  ndata$zone=A
  total <- rbind (total,ndata)
}

#Saving the aggregated file --> moved it later to PTSD Descriptive (for descriptive paper ) Folder

write.csv(total,"Desktop/PTSD/PTSD Data/stressmoments.csv", row.names = FALSE)

#count number of people reported stress moments in each zone, for instance in DC 20 people reported stress.
library(data.table)
setDT(total)[, .(count = uniqueN(i)), by = zone]

#heart rate mean without zeros and NA

hrlist <- total$hr [!total$hr==0]
sort (hrlist)
mean (hrlist, na.rm =  TRUE)
sd(hrlist,na.rm = TRUE)

# Kernel Density Plot
d <- density(hrlist, na.rm = TRUE) # returns the density data 
plot(d, main="",
     xlab="Heart Rate",
     ylab="Density",) # plots the results

hist(hrlist, main="",
     xlab="Heart Rate",
     ylab="Density",labels=TRUE) 
#### Plotting time vs stress moments

minute <- as.POSIXlt(as.character(total$time), format="%H:%M:%S")
plot( minute, total$ptsd_moment, xlab="Time", ylab="Stress")
options(scipen=999)
hist(minute , breaks = "hours",labels=TRUE, freq = TRUE, xlab="Hour of Day",ylab="Frequency of Stress Moments", main="")



##Plot of heart rate measures in stress moments
plot( minute[!total$hr==0], total$hr[!total$hr==0], xlab="Time", ylab="Heart Rate in Stress Moments")



####Activity
total$linearacc = sqrt((total$linear_accel_x^2)+(total$linear_accel_y^2)+(total$linear_accel_z^2))

for (i in 1:1023)
{
  if (total$linearacc[i] > 1.5) 
    {total$activity[i] <- "Biking"}
  else if (total$linearacc[i] <1.5 && total$linearacc[i]>0.5) {total$activity[i] <- "Walking"}
  else (total$activity[i] <- "Sitting")
} 

library(ggplot2)

#Activity plot vs stress counts
ggplot(total,
       aes(factor(activity))) +
  geom_bar(fill = "black",
           alpha = 0.8, width=.2) +
  theme_classic()+ ggtitle("") +
  xlab("Activity") + ylab("Number of Stress Moments")

##






