# script to Analyze Samsung data in working directory 
# Output is a tidy data set
# See README.md for explanation of script and tidy data set
library("dplyr")
library('stringr')
library('plyr')
library('tibble')
library('reshape2')

subject_test <-read.delim('./UCI HAR Dataset/test/subject_test.txt',header = FALSE, sep = "\t", dec = ".")
# giving the row# a column to itself
subject_test$index<-row(subject_test)
names(subject_test)<-c("subject","index")
head(subject_test)

y_test <-read.delim('./UCI HAR Dataset/test/y_test.txt',header = FALSE, sep = "\t", dec = ".")
y_test$index<-row(y_test)
names(y_test)<-c("y_numlabels", "index")
head(y_test)

test_data<-merge(subject_test,y_test,by="index")
head(test_data)

x_test <-read.delim('./UCI HAR Dataset/test/X_test.txt',header = FALSE, sep = "", dec = ".")
features<-read.delim('./UCI HAR Dataset/features.txt',header = FALSE, sep = "", dec = ".")
names(x_test)<-t(features[,2])
x_test$index <- seq.int(nrow(x_test))
head(x_test)

test_data2<-merge(test_data,x_test,by="index")
#-------------

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

train_data2<-merge(train_data,x_train,by="index")

all_data<-rbind(test_data2, train_data2)

#--------
#adding column to have 'word_labels' for activity beside numbered activity labels
activity <- read.table('./UCI HAR Dataset/activity_labels.txt',sep = "",col.names=c('num_label','name_label'))
all_data<-add_column(all_data, activity = 1:10299, .after = "y_numlabels")

#lookup function for turning y_numlabels into descriptive activity label
label_function <- function(x){activity[x,2]}
all_data$activity<-label_function(all_data$y_numlabels)


mean_cols<-colnames(all_data)[str_detect(names(all_data),'.mean.')]
std_cols<-colnames(all_data)[str_detect(names(all_data),'.std.')]
extracted_data<-all_data %>% select(index,activity,subject,mean_cols,std_cols)

x<-gsub("\\()","", names(extracted_data))
y<-gsub("-","_", x)
names(extracted_data)<-y

#summary breakdown of activity by subject/user
#table(extracted_data[,2:3])
# need to add back user and activity and index columns

dmelt<-melt(extracted_data[,c(2:82)],id=c("activity",'subject'),measure.vars=(names(extracted_data)[4:82]))
mean_by_activity <-dcast(dmelt,activity+subject~variable,mean)
View(mean_by_activity)
