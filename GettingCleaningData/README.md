# Peer-graded Assignment: Getting and Cleaning Data Course Project
This repository and its files have been created by @FranjoIM (**Franjo Ivankovic**) as a submission for _Peer-graded 
Assignment: Getting and Cleaning Data Course Project_ in _Getting and Cleaning Data_ course in Coursera's _Data Science 
Specialization_ series. This script was run on _UC Irvine_'s _Human Activity Recognition Using Smartphones Data Set_, which
can be found below.

- [x] [Human Activity Recognition Using Smartphones Data Set Website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)
- [x] [Human Activity Recognition Using Smartphones Data Set ZIP file used in this project](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

## Included Files
1. `CodeBook.md` - file containing variable description
2. `run_analysis.R` - file containing the script used to clean the data
3. `FinalData.txt` - final file with processed data
4. `README.md` - file containing information about the project and resulting files, code description, including assignment descriptions

## Code Description
### Introduction

The `run_analysis.R` script performes the five steps outlined in the _Peer-graded Assignment: Getting and 
Cleaning Data Course Project_. The purpose of this project was to collect, wrangle, and clean a data set.
Below, I am outlining the initial steps taken to prepare the data, followed by the explanation of the `run_analysis.R`
script itself.

### Data preparation and variable loading
1. The necessary libraries were loaded
```R
library(dplyr)
library(RCurl)
```
2. The dataset was downloaded and extracted into a `HARUS` folder using the following code:
```R
# Fetch the data
filename <- "HARUS.zip"

# Checking if zipfile has been alredy downloaded, and downloading the zipfile
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, paste("/Users/franjo/Desktop/MathewsLab.nosync/Practice/Coursera/Getting and Cleaning Data/data/",filename), method="curl")
}  

# Unzipping the zipfile
if (!file.exists("HARUS")) { 
  unzip(filename) 
}
```
3. Data was loaded into the RAM
```R
features <- read.table("HARUS/features.txt", col.names = c("n","functions"))
activities <- read.table("HARUS/activity_labels.txt", col.names = c("code", "activity"))
sTest <- read.table("HARUS/test/subject_test.txt", col.names = "subject")
xTest <- read.table("HARUS/test/X_test.txt", col.names = features$functions)
yTest <- read.table("HARUS/test/y_test.txt", col.names = "code")
sTrain <- read.table("HARUS/train/subject_train.txt", col.names = "subject")
xTrain <- read.table("HARUS/train/X_train.txt", col.names = features$functions)
yTrain <- read.table("HARUS/train/y_train.txt", col.names = "code")
```

### Data processing as required by the assignment
1. Merges the training and the test sets to create one data set.
```R
X <- rbind(xTrain, xTest)
```
> Binds `xTrain` and `xTest` data frames using `rbind()`
```R
Y <- rbind(yTrain, yTest)
```
> Binds `yTrain` and `yTest` data frames using `rbind()`
```R
S <- rbind(sTrain, sTest)
```
> Binds `sTrain` and `sTest` data frames using `rbind()`
```R
MD <- cbind(S, Y, X)
```
> Binds `S`, `Y` and `X` data frames using `cbind()`

2. Extracts only the measurements on the mean and standard deviation for each measurement.
```R
TD <- MD %>% select(subject, code, contains("mean"), contains("std"))
```
> Removes any variables that are not `subject`, `code`, or don't contain `mean` or `std` (standard deviation).

3. Uses descriptive activity names to name the activities in the data set.
```R
TD$code <- activities[TD$code, 2]
```
> Replaces numbers with corresponding descriptive activity

4. Appropriately labels the data set with descriptive variable names.
```R
names(TD)[2] = "Activity"
```
> The `code` column is now named `Activity`, for clarity
```R
names(TD)<-gsub("Acc", "Accelerometer", names(TD))
```
> The `Acc` column is now named `Accelerometer`, for clarity
```R
names(TD)<-gsub("Gyro", "Gyroscope", names(TD))
```
> The `Gyro` column is now named `Gyroscope`, for clarity
```R
names(TD)<-gsub("BodyBody", "Body", names(TD))
```
> The `BodyBody` column is now named `Body`, to reduce redundancy
```R
names(TD)<-gsub("Mag", "Magnitude", names(TD))
```
> The `Mag` column is now named `Magnitude`, for clarity
```R
names(TD)<-gsub("^t", "Time", names(TD))
```
> The columns starting with `^t` now replaced with `Time`, for clarity
```R
names(TD)<-gsub("^f", "Frequency", names(TD))
```
> The columns starting with `^f` now replaced with `Frequency`, for clarity
```R
names(TD)<-gsub("tBody", "TimeBody", names(TD))
```
> The `tBody` column is now named `TimeBody`, for clarity
```R
names(TD)<-gsub("-mean()", "Mean", names(TD), ignore.case = TRUE)
```
> The `-mean()` in columns is now replaced with `Mean`, for simplicity
```R
names(TD)<-gsub("-std()", "SandardDeviation", names(TD), ignore.case = TRUE)
```
> The `-std()` in columns is now replaced with `SandardDeviation`, for simplicity
```R
names(TD)<-gsub("-freq()", "Frequency", names(TD), ignore.case = TRUE)
```
> The `-freq()` in columns is now replaced with `Frequency`, for simplicity
```R
names(TD)<-gsub("angle", "Angle", names(TD))
```
> The `angle` column is now named `Angle`, for case consistency
```R
names(TD)<-gsub("gravity", "Gravity", names(TD))
```
> The `gravity` column is now named `Gravity`, for case consistency

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```R
FD <- TD %>% group_by(subject, Activity) %>% summarise_all(list(mean=mean))
write.table(FD, "FinalData.txt", row.name=FALSE)
```
> In the first line, we group the `TD` first by `subject`, then by `Activity`. Which is then fed into a `summarise` function to compute `mean` for each variable. The result is fed into a separate table, `FD`.
> In the second line, this table is saved as `FinalData.txt` with eliminated row names.

## Assignment Description
(Copied from Coursera's course project assignment _Instruction_ tab).

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set.

**Review criteria**
- [x] The submitted data set is tidy.
- [x] The Github repo contains the required scripts.
- [x] GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
- [x] The README that explains the analysis files is clear and understandable.
- [x] The work submitted for this project is the work of the student who submitted it.

**Getting and Cleaning Data Course Project**

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!


