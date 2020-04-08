# Set the working directory
setwd("~/Desktop/MathewsLab.nosync/Practice/Coursera/Exploratory Data Analysis/Coure Project 1")

# Load the necessary packages
library(dplyr)

# Load the data file
HPC <- read.table("household_power_consumption.txt", header=TRUE, sep=";", na.strings = "?", colClasses = c('character','character','numeric','numeric','numeric','numeric','numeric','numeric','numeric'))
head(HPC, 2)

# Tidy up the data table
HPC <- HPC[complete.cases(HPC),]

# Convert Date column into date/time type variable and only select data points form
# February 1st and 2nd of 2007
HPC$Date <- as.Date(HPC$Date,"%d/%m/%Y")
HPC <- HPC %>% filter(Date == "2007-02-01" | Date == "2007-02-02")


dateTime <- paste(HPC$Date, HPC$Time)
dateTime <- setNames(dateTime, "DateTime")
HPC <- HPC[ ,!(names(HPC) %in% c("Date","Time"))]

HPC <- cbind(dateTime, HPC)
HPC$dateTime <- as.POSIXct(dateTime)

# Create Plot 2

png("plot3.png",width=480,height=480,units="px")

with(HPC, {
  plot(Sub_metering_1~dateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
  lines(Sub_metering_2~dateTime,col='Red')
  lines(Sub_metering_3~dateTime,col='Blue')
})
legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

legend("topright", col=c("black", "red", "blue"), lwd=c(1,1,1), 
     c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()
