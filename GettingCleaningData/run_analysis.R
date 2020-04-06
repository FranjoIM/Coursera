# Merges the training and the test sets to create one data set.
X <- rbind(xTrain, xTest)
Y <- rbind(yTrain, yTest)
S <- rbind(subjectTrain, subjectTest)
MD <- cbind(S, Y, X)

# Extracts only the measurements on the mean and standard deviation for each measurement.
TD <- MD %>% select(subject, code, contains("mean"), contains("std"))

# Uses descriptive activity names to name the activities in the data set.
TD$code <- activities[TD$code, 2]

# Appropriately labels the data set with descriptive variable names.
names(TD)[2] = "Activity"
names(TD)<-gsub("Acc", "Accelerometer", names(TD))
names(TD)<-gsub("Gyro", "Gyroscope", names(TD))
names(TD)<-gsub("BodyBody", "Body", names(TD))
names(TD)<-gsub("Mag", "Magnitude", names(TD))
names(TD)<-gsub("^t", "Time", names(TD))
names(TD)<-gsub("^f", "Frequency", names(TD))
names(TD)<-gsub("tBody", "TimeBody", names(TD))
names(TD)<-gsub("-mean()", "Mean", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-std()", "SandardDeviation", names(TD), ignore.case = TRUE)
names(TD)<-gsub("-freq()", "Frequency", names(TD), ignore.case = TRUE)
names(TD)<-gsub("angle", "Angle", names(TD))
names(TD)<-gsub("gravity", "Gravity", names(TD))

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
FD <- TD %>%
  group_by(subject, Activity) %>%
  summarise_all(list(mean=mean))
write.table(FD, "FinalData.txt", row.name=FALSE)
