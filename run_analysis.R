# Getting and Cleaning Data: Project 1: run_analysis
# created by Adrienne Lehnert: July 23, 2015

# Load libraries for use in script
library(dplyr)

## Read and find the mean and std columns
features<-read.table("features.txt",stringsAsFactors=FALSE)[,2] # Get names of variables
activity_labels<-read.table("activity_labels.txt",stringsAsFactors=FALSE)[,2] # Get names of activities
m<-grep("-mean()",features,ignore.case=FALSE)  # Find "mean" columns
s<-grep("-std()",features,ignore.case=FALSE)   # Find "std" columns
cols<-sort(c(m,s)) # Collect "mean" and "std" columns into single sorted vector

## Read training set
TrainData<-read.table("./train/X_train.txt",stringsAsFactors=FALSE) # read the training data
TrainLabels<-read.table("./train/y_train.txt",stringsAsFactors=FALSE) # read the training data labels
TrainSubject<-read.table("./train/subject_train.txt",stringsAsFactors=FALSE) # read the training data subject info

## Create training set
names(TrainData)<-features # Set names of training data variables
TrainData<-TrainData[,cols] # Collect "mean" and "std" columns of training data
TrainData<-cbind(Activity=TrainLabels$V1,TrainData) # Add in column of activity labels
TrainData<-cbind(Subject=TrainSubject$V1,TrainData) # Add in column of subject info

## Read testing set
TestData<-read.table("./test/X_test.txt",stringsAsFactors=FALSE) # read the testing data
TestLabels<-read.table("./test/y_test.txt",stringsAsFactors=FALSE) # read the testing training labels
TestSubject<-read.table("./test/subject_test.txt",stringsAsFactors=FALSE) # read the testing data subject info

## Create testing set
names(TestData)<-features # Set names of testing variables (same as training variables)
TestData<-TestData[,cols] # Collect "mean" and "std" columns of testing data
TestData<-cbind(Activity=TestLabels$V1,TestData) # Add in column of activity labels 
TestData<-cbind(Subject=TestSubject$V1,TestData) # Add in column of subject info

## Create Merged data
Data<-rbind(TestData,TrainData) # Combine data sets
Data<-Data[,-grep("meanFreq",names(Data))] # Remove the "meanFreq" data columns
rm(list=setdiff(ls(), "Data"))  # Clean up everything except data frame of merged data


## Reassign activity numbers to descriptive data names
"walking"->Data[Data$Activity==1,"Activity"]
"walking_upstairs"->Data[Data$Activity==2,"Activity"]
"walking_downstairs"->Data[Data$Activity==3,"Activity"]
"sitting"->Data[Data$Activity==4,"Activity"]
"standing"->Data[Data$Activity==5,"Activity"]
"laying"->Data[Data$Activity==6,"Activity"]

## Make Tidy Data Set
tidyData<- Data %>% group_by(Subject,Activity) %>% summarise_each(funs(mean)) # Calculate tidy data set
write.table((tidyData),file="Tidy_Data.txt", row.names=FALSE) # Write tidyData to txt file
