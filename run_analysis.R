#Initialize the "plyr" library
library("plyr")

#Initialize the messy_dataset and tidy_dataset global variables
messy_dataset <- NULL
tidy_dataset <- NULL

#Defines the analyze_samsung_data function
analyze_samsung_data <- function() {    
  
  #Open features.txt and store in features variable
  features <- read.table("features.txt");
  colnames(features) <- c("FeatureId", "FeatureLabel")
  
  #Load activity labels and set the column names
  activity_labels <- read.table("activity_labels.txt");
  colnames(activity_labels) <- c("ActivityId", "ActivityLabel")
  
  #Load the training data into variables
  train_subject <-read.table("train/subject_train.txt")
  train_x  <- read.table("train/X_train.txt");
  train_y <- read.table("train/y_train.txt");

  #Load the test data into variables
  test_subject <-read.table("test/subject_test.txt")
  test_x <- read.table("test/X_test.txt");
  test_y <- read.table("test/y_test.txt");
  
  #combine the training and test x values and name the columns based off of features
  raw_x <- rbind(train_x,test_x)
  colnames(raw_x) <- features$FeatureLabel
  
  #The values representing the mean and standard deviation are filtered
  filtered_x <- raw_x[,c(grep("-mean",colnames(raw_x)),grep("-std",colnames(raw_x)))]
  
  #set Tidy column headers and save them for later reference
  variable_column_names <- gsub("-","",gsub("()","",gsub("^f","Frequency",gsub("^t","Time",gsub("-std","StandardDeviation",gsub("-mean","Mean",colnames(filtered_x))))),fixed=TRUE))
  colnames(filtered_x) <- variable_column_names
  
  #Combine test and training y data and set the column name to ActivityId
  raw_y <- rbind(train_y,test_y)
  colnames(raw_y) <- "ActivityId"
  
  #Bind SubjectData together and set the column name to Subject
  raw_subject <- rbind(train_subject,test_subject)
  colnames(raw_subject) <- c("Subject")
  
  #bind all the columns together so subject,activity,and measurement variables are the columns
  bound_data <- cbind(raw_subject,raw_y,filtered_x)
  
  #merge the activity labels to the dataset and assign it to messy_dataset
  messy_dataset <<- merge(activity_labels, bound_data)  
  
  #Calculate the mean of the variable columns grouped by subject and activity label, and assign tidy column names
  tidy_dataset <<- ddply(messy_dataset, c("Subject","ActivityLabel"),colwise(mean, variable_column_names))  
  colnames(tidy_dataset) <<- c("Subject","Activity",paste0("Mean",variable_column_names))
}

#Call function. This ensures only messy_dataset and tidy_dataset end up in the environment
analyze_samsung_data()

#Save file to disk
write.table(tidy_dataset,"tidy_dataset.txt", row.name=FALSE)