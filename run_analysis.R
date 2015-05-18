#check if following packages are installed and then install if not
if("plyr" %in% rownames(installed.packages()) == FALSE) {install.packages("plyr")}
if("dplyr" %in% rownames(installed.packages()) == FALSE) {install.packages("dplyr")}
library(plyr)
library(dplyr)

#check to see if the file dataset.zip already exists in R working directory
if (!file.exists("Dataset.zip")){
    #set url for file location
    url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(url, "dataset.zip")       
}
# unzip file to working directory
unzip("dataset.zip")

# load training data points, activity and subjects
x_traint <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_traint <- read.table("./UCI HAR Dataset/train/Y_train.txt")
s_traint <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# load test data points, activity and subjects
x_testt <-read.table("./UCI HAR Dataset/test/X_test.txt") #data
y_testt <- read.table("./UCI HAR Dataset/test/Y_test.txt") #activity
s_testt <- read.table("./UCI HAR Dataset/test/subject_test.txt") #subjects

#combine subject, activity and data columns to test and train datasets
traint <- cbind(x_traint, y_traint, s_traint)
testt <- cbind(x_testt, y_testt, s_testt)

# combine test and train datasets into a single data.frame called full_set
full_set <-rbind(traint, testt)

#import feature descriptions
columnlabels <- read.table("./UCI HAR Dataset/features.txt")

# work out which columns have mean in their name
mean_names<-grep("mean", columnlabels[,2], ignore.case=TRUE)
# probably a really poor way of cleansing and replacing characters below.
mean_names_values <- grep("mean", columnlabels[,2], ignore.case=TRUE, value=TRUE)
mean_names_values <- gsub("()-", "_", mean_names_values, fixed=TRUE)
mean_names_values <- gsub("()", "", mean_names_values, fixed=TRUE)
mean_names_values <- gsub("-", "_", mean_names_values, fixed=TRUE)
mean_names_values <- gsub("(", "_", mean_names_values, fixed=TRUE)
mean_names_values <- gsub(")", "_", mean_names_values, fixed=TRUE)
mean_names_values <- gsub(",", "_", mean_names_values, fixed=TRUE)
mean_names_values <- gsub("_$", "", mean_names_values)

# work out which columns have std in their name
std_names <-grep("std", columnlabels[,2], ignore.case=TRUE)
std_names_values <-grep("std", columnlabels[,2], ignore.case=TRUE, value=TRUE)
std_names_values <- gsub("()-", "_", std_names_values, fixed=TRUE)
std_names_values <- gsub("()", "", std_names_values, fixed=TRUE)
std_names_values <- gsub("-", "_", std_names_values, fixed=TRUE)
std_names_values <- gsub("(", "_", std_names_values, fixed=TRUE)
std_names_values <- gsub(")", "_", std_names_values, fixed=TRUE)
std_names_values <- gsub(",", "_", std_names_values, fixed=TRUE)
std_names_values <- gsub("_$", "", std_names_values)

# work out a subset of data based on the above 
x_set_mean <- full_set[,c(mean_names)]
x_set_std <- full_set[,c(std_names)]
x_set_desc <- full_set[,(562:563)]

# set column labels to subset data
colnames(x_set_mean) <-mean_names_values
colnames(x_set_std) <-std_names_values
colnames(x_set_desc) <-c("activityID", "subject")

# combine datasets again
x_subset <- cbind(x_set_mean, x_set_std, x_set_desc)

# load activity names
activitynames <- read.table("./UCI HAR Dataset/activity_labels.txt")


# use innerjoin on activity and id from subset and activitynames tables to append activity name to subset
x_subset_join <- inner_join(x_subset,activitynames, by=c("activityID" = "V1"))

# drop the activity ID column from subset
x_subset_join <- x_subset_join[,c(1:86,88:89)]

# rename V2 column to activity
x_subset_join <- rename(x_subset_join, activity = V2)

# perform mean calculation on all numerical columns grouped by activity and subject
x_sum <- ddply(x_subset_join, c("activity", "subject"), numcolwise(mean))
write.table(x_sum, file="x_sum.txt", row.name=FALSE)


