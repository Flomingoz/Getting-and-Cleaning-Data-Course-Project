#This file is written by Florent Zwiers for the John Hopkins University course 'Getting and Cleaning Data'
#the first section will make sure the data is all there. After that, each of the five steps of the project will be separated by a comment mentioning the step.

#set fileURL as per exercise
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#check if a datafolder exists and created it not, then check if the zip file is there and download it if not, and finally check that it has been unzipped and do so if not.
if(!file.exists("./data")) {
        dir.create("./data")
}

if(!file.exists("./data/project_Dataset.zip")) {
        download.file(fileURL,destfile="./data/UCI_HAR_Dataset.zip")
}

if(!file.exists("./data/UCI\ HAR\ Dataset")) {
        unzip(zipfile="./data/UCI_HAR_Dataset.zip", exdir="./data")
}

#Read data into variables
wdpath <- "./data/UCI\ HAR\ Dataset"
TrainingSet  <- read.table(paste0(wdpath, "/train/X_train.txt"), header = FALSE)
TestSet <- read.table(paste0(wdpath, "/test/X_test.txt"), header = FALSE)
TrainingLabels <- read.table(paste0(wdpath, "/train/y_train.txt"), header = FALSE)  
TestLabels <- read.table(paste0(wdpath, "/test/y_test.txt"), header = FALSE)
SubjectTrain <- read.table(paste0(wdpath, "/train/subject_train.txt"), header = FALSE)
SubjectTest  <- read.table(paste0(wdpath, "/test/subject_test.txt"), header = FALSE)


#STEP 1: Merges the training and the test sets to create one data set.
#merge test and training sets
TotalSubject <- rbind(SubjectTrain, SubjectTest)
TotalLabels <- rbind(TrainingLabels, TestLabels)
TotalSet <- rbind(TrainingSet, TestSet)
#set names to variables
names(TotalSubject)<-c("subject")
names(TotalLabels)<- c("activity")
SetNames <- read.table(paste0(wdpath, "/features.txt"),head=FALSE)
names(TotalSet)<- SetNames$V2
#merge it all into one dataframe
CombinedDF <- cbind(TotalSet, TotalSubject, TotalLabels)

#STEP 2: Extracts only the measurements on the mean and standard deviation for each measurement.
subdataSetNames <- SetNames$V2[grep("mean\\(|std\\(", SetNames$V2)]
selectedColumns <- c(as.character(subdataSetNames), "subject", "activity" )
MeanStdData <- subset(CombinedDF, select = selectedColumns)

#STEP 3: Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table(paste0(wdpath, "/activity_labels.txt"),header = FALSE)
MeanStdData$activity <-factor(MeanStdData$activity, labels=activityLabels[,2])

#STEP 4: Appropriately labels the data set with descriptive variable names.
names(MeanStdData)<-gsub("\\(|\\)", "", names(MeanStdData))
names(MeanStdData)<-gsub("^t", "time", names(MeanStdData))
names(MeanStdData)<-gsub("^f", "frequency", names(MeanStdData))
names(MeanStdData)<-gsub("Acc", "Accelerometer", names(MeanStdData))
names(MeanStdData)<-gsub("Gyro", "Gyroscope", names(MeanStdData))
names(MeanStdData)<-gsub("Mag", "Magnitude", names(MeanStdData))
names(MeanStdData)<-gsub("BodyBody", "Body", names(MeanStdData))


#STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
TidyData <- aggregate(. ~subject + activity, MeanStdData, mean)
#order subject and activity to the front
TidyData <- TidyData[order(TidyData$subject, TidyData$activity),]
#write it into a dataset
write.table(TidyData, file = "data/tidydata.txt", row.name=FALSE, quote = FALSE, sep = '\t')