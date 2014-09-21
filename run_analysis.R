#         Getting and Cleaning Data Course Project

# You should create one R script called run_analysis.R that does the following. 
#1) Merges the training and the test sets to create one data set.
#2) Extracts only the measurements on the mean and standard deviation 
#	for each measurement. 
#3) Uses descriptive activity names to name the activities in the data set
#4) Appropriately labels the data set with descriptive variable names. 
#5) From the data set in step 4, creates a second, independent tidy data 
#	set with the average of each variable for each activity and each subject.


#	This script does not create a usable function, rather
# running this script from the R Gui Command Line will load the various
# data into memory and print out a summary of the tidy data set.

# Load the libraries we'll need
library(dplyr)
library(tidyr)

## Load the label tables into memory
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
featureLabels <- read.table("UCI HAR Dataset/features.txt")

# Read the data tables into memory.  Since the internial tables contain no
#	mean or std, they'll be ignored in the end anyway, so don't load those.
trainSubject <- read.table("UCI HAR Dataset/train/subject_train.txt")
trainActivityID <- read.table("UCI HAR Dataset/train/y_train.txt")
trainData <- read.table("UCI HAR Dataset/train/x_train.txt")

testSubject <- read.table("UCI HAR Dataset/test/subject_test.txt")
testActivityID <- read.table("UCI HAR Dataset/test/y_test.txt")
testData <- read.table("UCI HAR Dataset/test/x_test.txt")

## Name the columns first
colnames(trainActivityID) <- "ActivityID"
colnames(trainSubject) <- "Subject"
colnames(trainData) <- as.character(featureLabels$V2)
colnames(testActivityID) <- "ActivityID"
colnames(testSubject) <- "Subject"
colnames(testData) <- as.character(featureLabels$V2)

## Bind the subject & activity names
trainData <- cbind(trainSubject, trainActivityID, trainData)
testData <- cbind(testSubject, testActivityID, testData)

## Step 1 and 2 -- Merge the training and test, and select only mean and std
trainData <- select(trainData, Subject, ActivityID, contains("mean"), contains("std"))
testData <- select(testData, Subject, ActivityID, contains("mean"), contains("std"))
data <- rbind(trainData, testData)

## Step 3 Use descriptive activity names
data <- mutate(data, ActivityID=activityLabels$V2[ActivityID])

## Step 4 Appropriately label data sets
##	Expanding the abbreviations would make the variable names very very long,
##	which may cause them to be truncated or not imported in some software.  What
##	I can do is remove the symbols.

names <- colnames(data)
names <- gsub("\\(\\)", "", names)
names <- gsub("-", " ", names)
colnames(data) <- names

## Step 5 Create a second, independently tidy data set with the average of each
##	variable for each activity and each subject.
tidyData <- ddply(data, .(Subject, ActivityID), colwise(mean))
tidyNames <- colnames(tidyData)
tidyNames <- paste("Average ", tidyNames, sep="")
colnames(tidyData) <- tidyNames
tidyData <- rename(tidyData, c("Average Subject" = "Subject", "Average ActivityID" = "Activity"))


## Write 
write.table(tidyData, file="tidyData.txt", sep=",")
print("Done")

# Print out a summary of the tidy data set
# Write the tidy dataset to a file