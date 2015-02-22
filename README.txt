==================================================================
Getting and Cleaning Data - Course Project
Version 1.0
==================================================================
Kellan Zheng

This project consists of an R script that transforms the raw data from the "Human Activity Recognition Using Smartphones Dataset" into a tidy dataset ("output.txt") in the following manner: 

    1. Merges the training and the test sets to create one data set.
    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
    3. Uses descriptive activity names to name the activities in the data set
    4. Appropriately labels the data set with descriptive variable names. 
    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The submission consists of the following:
	1. run_analysis.R - R script that takes the raw dataset and transforms it into a tidy dataset ("output.txt") - see Script Details for a walkthrough of the script
	2. CodeBook.txt - text file specifying the variables that exist in the output file "output.txt"
	3. README.txt
	
==================================================================
Script Details
==================================================================
	
PREREQUISITES
The following R packages, besides the default packages available in R version 3.1.2, need to be installed before running the script. The script will load this dataset up if it is not yet loaded.
	1. dplyr
	2. reshape2

This script starts with the assumption that the Samsung data is available in the working directory in an unzipped "UCI HAR Dataset" folder. The data is available at: 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The script performs the following actions:

	1. Load both the training and test raw data sets into R.
		a. Each raw data set is located within subdirectories in "UCI HAR Dataset" and contains:
			i. test/X_test.txt - 2947 observations
			ii. train/X_train.txt - 7352 observations
		b. Merge the training and test raw data sets with rbind to create one raw data set.
	3. Extracts mean and standard deviation related columns from the raw data set.
		a. The script opens the index of variable names for the raw dataset (features.txt) and filters for the strings "std", "mean" and "Mean". What results is an index of variable names (called "names_filtered") containing these strings (86 variables).
		b. Then it reduces the combined data set by selecting only the 86 columns corresponding to this index.
	4. Appropriately labels the data set with descriptive variable names.	
		a. Each column is then renamed based on the full names provided in the "names_filtered" index.
	5. Adds the subject ID to this data frame.
		a. Load the subject files into R - these have the same number of rows as their corresponding data sets.
			i. test/subject_test.txt
			ii. train/subject_train.txt
		b. Merge these subject lists in the same manner as the raw data set with rbind (preserving the order of rows).
		c. Combine this subject list to the data frame from the previous step with cbind.	
	6. Applies descriptive activity names to each observation in the data set.
		a. Load the activity labels index file into R ("activity_labels.txt").
		b. Load both Y label sets into R - these have the same number of rows as their corresponding raw data sets.
			i. test/Y_test.txt
			ii. train/Y_train.txt
		c. Merge the Y sets in the same manner as the raw data set with rbind (preserving the order of rows).
		d. Combine this Y set to the data set from the previous step with cbind.
		e. Left join the activity labels index to this data set, using the values from the Y set as a lookup. This creates a new column called "activityName" containing the corresponding activity for each observation.
			i. Note that this scrambles the original order of observations.
	7. Creates a second, independent data set with the average of each variable for each activity.
		a. Using reshape2's melt and dcast function, the script computes the mean of each variable, for each combination of "subject" and "activityName".
		b. This data set is written to a file called "output.txt" in the working directory.

The output of this script is the tidy data set contained in "output.txt".