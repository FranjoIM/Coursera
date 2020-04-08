# Set the working directory
setwd("~/Desktop/MathewsLab.nosync/Practice/Coursera/Exploratory Data Analysis/Coure Project 1")

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

# Create a Plot 1
png("plot1.png",width=480,height=480,units="px")
with(HPC, hist(Global_active_power, col="red", main = "Global Active Power", 
               xlab="Global Active Power (kilowatts)"))
dev.off()

