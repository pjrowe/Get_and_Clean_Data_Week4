# This run_analysis.R script downloads and unzips the data from the Human Activity Recognition Using Smartphones 
# Dataset, Version 1.0 and then performs the following tasks, as described in more detail 
# in README.md.
# 
# 1. MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.
# 2. EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.
# 3. USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
# 4. APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
# 5. FROM THE DATA SET IN STEP 4, CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE    
#    FOR EACH ACTIVITY AND EACH SUBJECT.
#

library("dplyr")
library('stringr')
library('plyr')
library('tibble')
library('reshape2')
library(downloader)

# download and unzip files and record date / time of download
url<-'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
temp <- tempfile()
download(url,dest="dataset.zip",mode='wb')
unzip('dataset.zip')
date_downloaded<-Sys.time()

#
# 1. MERGES THE TRAINING AND THE TEST SETS TO CREATE ONE DATA SET.
#

# there are three test data files and three training data files.  We need to merge the three test files to create one
# large dataset, do the same for the training data, and then cbind the two larger blocks together 

# the subject labels file
subject_test <-read.delim('./UCI HAR Dataset/test/subject_test.txt',header = FALSE, sep = "\t", dec = ".")
# giving the row# a column to itself; we will use this index column to perform the merge  
subject_test$index<-row(subject_test)
names(subject_test)<-c("subject","index")
head(subject_test)
dim(subject_test)

# the file with the labels for the activity; this is a number (not a descriptive label) 
y_test <-read.delim('./UCI HAR Dataset/test/y_test.txt',header = FALSE, sep = "\t", dec = ".")

# giving the row# a column to itself; we will use this index column to perform the merge  
y_test$index<-row(y_test)
names(y_test)<-c("y_numlabels", "index")
head(y_test)

# merging by the index column,    
test_data<-merge(subject_test,y_test,by="index")
head(test_data)

# the file with the measured and calculated variables
x_test <-read.delim('./UCI HAR Dataset/test/X_test.txt',header = FALSE, sep = "", dec = ".")
# the following is the name of all those features.  These variable names are adequately descriptive, as per item 4 in 
# the requirements of this script file (4. APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES.)
features<-read.delim('./UCI HAR Dataset/features.txt',header = FALSE, sep = "", dec = ".")
names(x_test)<-t(features[,2])
# adding index column for doing a merge; cannot use row(x_test) because it adds too many columns
x_test$index <- seq.int(nrow(x_test)) 
head(x_test)

# this completes the merging of all the test data
test_data<-merge(test_data,x_test,by="index")

# Now on to merging the 3 training data files 
subject_train <-read.delim('./UCI HAR Dataset/train/subject_train.txt',header = FALSE, sep = "\t", dec = ".")
# giving the row# a column to itself
subject_train$index<-row(subject_train)
names(subject_train)<-c("subject","index")
head(subject_train)

y_train <-read.delim('./UCI HAR Dataset/train/y_train.txt',header = FALSE, sep = "\t", dec = ".")
y_train$index<-row(y_train)
names(y_train)<-c("y_numlabels", "index")
head(y_train)

train_data<-merge(subject_train,y_train,by="index")
head(train_data)

x_train <-read.delim('./UCI HAR Dataset/train/X_train.txt',header = FALSE, sep = "", dec = ".")
names(x_train)<-t(features[,2])
x_train$index <- seq.int(nrow(x_train))
head(x_train)

train_data<-merge(train_data,x_train,by="index")

# both blocks have the same  named columns, so we can use rbind() 
# not sure it matters if we put the test data first

all_data<-rbind(test_data, train_data)

#
# 2. EXTRACTS ONLY THE MEASUREMENTS ON THE MEAN AND STANDARD DEVIATION FOR EACH MEASUREMENT.
#
mean_cols<-colnames(all_data)[str_detect(names(all_data),'.mean.')]
std_cols<-colnames(all_data)[str_detect(names(all_data),'.std.')]
extracted_data<-all_data %>% select(index,y_numlabels,subject,mean_cols,std_cols)

x<-gsub("\\()","", names(extracted_data))
y<-gsub("-","_", x)
names(extracted_data)<-y

#
# 3. USES DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET
#
# we start by loading the data file matching the number label with the desciptive activity label
activity <- read.table('./UCI HAR Dataset/activity_labels.txt',sep = "",col.names=c('num_label','name_label'))
# then we add a column named 'word_labels' for activity beside numbered activity labels, starting with placeholder values
extracted_data<-add_column(extracted_data, activity = 1:length(extracted_data$index), .after = "y_numlabels")

# the label_function performs a lookup for turning y_numlabels into descriptive activity label, then remove y_numlabels
label_function <- function(x){activity[x,2]}
extracted_data$activity<-label_function(extracted_data$y_numlabels)
extracted_data <- select(extracted_data,-y_numlabels)

# summary breakdown of activity by subject/user
# table(extracted_data[,2:3])
# need to add back user and activity and index columns

#
# 4. APPROPRIATELY LABELS THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES
# This was already accomplished along the way by adding the feature names to the X data and mapping the descriptive activity
# name to the activity column

#
# 5. FROM THE DATA SET IN STEP 4, CREATES A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE    
#    FOR EACH ACTIVITY AND EACH SUBJECT.
#

# melt() creates a long dataset where all the x_data features in columns are melted down into two columns (variable,value)
# dcast() then calculates the mean for each activity/subject pair 
dmelt<-melt(extracted_data[,c(2:82)],id=c("activity",'subject'),measure.vars=(names(extracted_data)[4:82]))
mean_by_activity <-dcast(dmelt,activity+subject~variable,mean)
View(mean_by_activity)

# creates the file with the tidy data
write.table(mean_by_activity,file="tidy_data.txt", row.name=FALSE)

#  EXTRA CODE
#
#
#
#
#
#
#
# Presentation Code for README.md and CodeBook.md
# code to display mean_variables
num_means<-length(mean_cols)
mean_pad<-(num_means%%3!=0)*(3-num_means%%3)

num_stdevs<-length(std_cols)
stdev_pad<-(num_stdevs%%3!=0)*(3-num_stdevs%%3)

mean_variables<-mean_cols %>%  c(rep("",mean_pad)) %>%matrix(ceiling(num_means/3),3) %>% data.frame()
col_1<-as.character(paste("Columns ",1,'-',ceiling(num_means/3),sep="",collapse = NULL))
col_2<-as.character(paste("Columns ",ceiling(num_means/3)+1,'-',2*ceiling(num_means/3),sep="",collapse = NULL))
col_3<-as.character(paste("Columns ",2*ceiling(num_means/3)+1,'-',3*ceiling(num_means/3)-mean_pad,sep="",collapse = NULL))
names(mean_variables)<-c(col_1,col_2,col_3)
mean_variables

stdev_variables<-std_cols %>% c(rep("",stdev_pad)) %>%matrix(ceiling(num_stdevs/3),3) %>% data.frame()
col_1<-as.character(paste("Columns ",1,'-',ceiling(num_stdevs/3),sep="",collapse = NULL))
col_2<-as.character(paste("Columns ",ceiling(num_stdevs/3)+1,'-',2*ceiling(num_stdevs/3),sep="",collapse = NULL))
col_3<-as.character(paste("Columns ",2*ceiling(num_stdevs/3)+1,'-',3*ceiling(num_stdevs/3)-stdev_pad,sep="",collapse = NULL))
names(stdev_variables)<-c(col_1,col_2,col_3)
stdev_variables

dataframevar<-c('y_test','subject_test','X_test','X_train','y_train','subject_train')
df<-data.frame(dim(subject_test), dim(x_test),dim(subject_test),dim(y_train), dim(x_train),dim(subject_train))
row.names(df)<-c('rows','columns')
t(df)