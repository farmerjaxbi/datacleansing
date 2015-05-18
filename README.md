==================================================================
Human Activity Recognition Using Smartphones Dataset
Version 1.0
==================================================================

Assumptions:
==================================================================
With this analysis the following assumptions have been made:
It has been developed on an Windows 8 operating system with downloaded files coded appropriately.
It works with R studio 0.98.1103 and R code base 3.2.0.  It does not work with 3.1.2 and has not been tested with previous versions.


Code performs the following:
==================================================================
- First up the analysis checks to see if the packages "plyr" and "dplyr" are installed, if not then it installs them as there are dependent functions from each.
- Next the code checks your working directory for the file dataset.zip, if it finds it continues else it downloads the file again.
- Unzips the dataset.zip to the working directory
- load training data points, activity and subjects into variables
- load test data points, activity and subjects into variables
- combine columns subject, activity and data columns within each of teh test and train datasets
- combine rows of test and train datasets into a single data.frame called full_set
- import feature descriptions, ie the names of the columns
- work out which columns have mean or std in their name
- cleanse the names of the dataset by pulling out some characters from poorly descibed column names
- work out a subset of the full data set based on the above names
- set column labels to subset data in each of the variables
- combine the mean, std and description sub data sets
- load activity names into a new variable
- use innerjoin on activity and id from subset and activitynames tables to append activity name to subset
- drop the activity ID column from subset
- using ddply perform mean calculation on all numerical columns grouped by activity and subject
- write output file of results to "x_sum.txt"


The dataset includes the following files:
==================================================================
- README.md :  this file
- CodeBook.md : describes the variables in the output file
- run_analysis.R : the source code for the data cleansing excercise



