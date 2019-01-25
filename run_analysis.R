# This script creates a tidy data set from the "Human Activity Recognition Using
# Smartphones Data Set" from the University of California, Irvine.  The original
# data set can be found here:
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

# Get column indices and labels for mean and standard deviation from features.txt
features <- read.delim("./data/features.txt", header=FALSE, sep=" ", 
                       col.names=c("idx" , "labels"))
pattern <- ".*-(mean|std)\\(\\).*"
fidx <- grep(pattern, features$labels)
flabels <- grep(pattern, features$labels, value=T)

# Get activity labels
activities <- read.delim("./data/activity_labels.txt", header=FALSE,  sep=" ", 
                         col.names=c("idx" , "labels"), as.is=TRUE)

# The following function is used to fetch the training/test data
# path1 is the path to the dataset, which I gziped to meet GitHub's file size guidelines
# path2 is the path to the lables
# path3 is the path to the subjects
# idx is a vector containing the column indices of interest 
# labels is a vector containing the labels for the columns
# acts is a data frame containing the mapping of integers to activity labels
getData <- function(path1, path2, path3, idx, labels, acts) {
  # Read data set and activity labels
  con <- gzfile(path1)
  data <- read.table(con, header=FALSE, nrows=-1)
  activities <- read.table(path2, header=FALSE, col.name=c("activity"), nrows=-1)
  subjects <- read.table(path3, header=FALSE, col.name=c("subject"), nrows=-1)
  
  # Subset data and rename the column names
  data <- data[,idx]
  names(data) <- labels
  
  # Apply activities
  data$activity <- activities$activity
  for(i in 1:nrow(data)) {
    idx <- data[i,"activity"]
    data[i,"activity"] <- acts[idx,"labels"]
  }
  
  # Apply subjects
  data$subject <- subjects$subject
  
  return(data)
}


# Get data for training and test, join them together using rbind
measurements <- rbind(getData("./data/test/X_test.txt.gz", "./data/test/y_test.txt", 
                      "./data/test/subject_test.txt", fidx, flabels, activities), 
                      getData("./data/train/X_train.txt.gz", "./data/train/y_train.txt", 
                      "./data/train/subject_train.txt", fidx, flabels, activities))

# Output tidy data
write.csv(measurements, "measurements.csv")

# create a second tidy data set for the averages
activity <- unique(measurements$activity)
byActivity <- data.frame(row.names=activity)
for(col in flabels) {
  byActivity[[col]] <- tapply(measurements[,col], measurements$activity, mean)
}
subject <- unique(measurements$subject)
bySubject <- data.frame(row.names=subject)
for(col in flabels) {
  bySubject[[col]] <- tapply(measurements[,col], measurements$subject, mean)
}

averages <- rbind(byActivity, bySubject)

# Output second tidy data set
write.csv(averages, "averages.csv")

