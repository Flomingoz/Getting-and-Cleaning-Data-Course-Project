this repository contains the R script, the tidy data file, and this readme file.

The "run_analysis.R" script starts by setting the URL (as per the corusera course) and then checks if the file exists (in a folder called /data) and if it is unzipped. If not it will create the folder, download the file, and unzip it as needed. 
After that the path to the data is set and the data read into variables.

After that the five steps of the assignment/project are performed. In short, they are:
1. merging the data sets (test and training)
2. extracting mean and standard deviations for all measurements
3. giving descriptive activity names to the activities in the dataset (using the "activity labels" file in the dataset)
4. giving labels with descriptive variable names (i.e. removing abbreviations and superfluous punctuation marks)
5. creating a new tidy dataset with the average for each activity and subject 
