#   This script is for the Course Project for "Getting and Cleaning Data." The goal is to do the following:
#
#   1.  Merges the training and the test sets to create one data set.
#   2.  Extracts only the measurements on the mean and standard deviation for each measurement. 
#   3.  Uses descriptive activity names to name the activities in the data set
#   4.  Appropriately labels the data set with descriptive variable names. 
#   5.  From the data set in step 4, creates a second, independent tidy data set 
#       with the average of each variable for each activity and each subject.

library(dplyr)
library(reshape2)

# Load both the training and test raw data sets into R.

X_test <- read.table("UCI HAR Dataset/test/X_test.txt")
X_train <- read.table("UCI HAR Dataset/train/X_train.txt")

# Merge the training and test raw data sets to create one combined raw data set.
X <- rbind(X_test, X_train)

# Open the index of variable names (features.txt)
# We are only interested in the mean and standard deviations. Thus, we will
# filter only for the names of variables that contain "std" or "mean" within
# the list of names.

names <- read.table("UCI HAR Dataset/features.txt")
names_filtered <- filter(names,grepl("std",V2) | grepl("mean",V2) | grepl("Mean",V2))

# Subset the combined raw data to obtain only columns with "std" or "mean" in their
# variable names, using the index of the filtered names list.

X <- X[names_filtered[[1]]]

# Because the columns of the new data set correspond to the filtered names list,
# we can replace the names of this dataframe with the filtered names list.

names(X) <- names_filtered[[2]]

# Naming the activities with detailed labels
# Load the activity_labels file into R
# Rename the indices to be more detailed

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels <- rename(activity_labels, activityIndex = V1, activityName = V2)

# Adding subject columns to this data frame
# Load both the training and test subject_test files into R.
# Merge the subject sets with rbind in the same manner as the actual data set.
# Combine this to our current data frame
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject <- rbind(subject_test, subject_train)
subject <- rename(subject, subject = V1)
X <- cbind(X, subject)

# Load both the training and test Y files into R.
# Merge the Y sets with rbind in the same manner as the actual data set.
# Rename this column of data to "activityName"

Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
Y <- rbind(Y_test, Y_train)
Y <- rename(Y, activityIndex = V1)

# Combine this with our current data frame, then drop the activityNameIndex column
X <- cbind(X, Y)
X <- merge(X,activity_labels,by = "activityIndex", all.x = TRUE)
X <- select(X,-activityIndex)

# Summarize the data by averaging each value, for each subject and each activity, creating a new data frame.

Xmelt <- melt(X, id.vars = c("subject","activityName"))
Xsummary <- dcast(Xmelt, subject+activityName ~ variable, mean)

# Write output to txt file
write.table(Xsummary, file = "output.txt", row.names = FALSE)
