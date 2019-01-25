# Human Activity Recognition Using Smartphones Data Set

This script creates a tidy data set from the "Human Activity Recognition Using Smartphones Data Set" from the University of California, Irvine.  The original data set can be found [here](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).

## Files/Directories

- `data`: Directory containing a copy of the original data set.  The only modification that was made was the test and training data was compressed to meet GitHub's file size guidelines.
- `run_analysis.R`: Script used to transform the original data set into measurements.csv and averages.csv.  See "Analysis" below for more details.
- `measurements.csv`: All test and training set meesurements combined into a single file including descriptive labels for activities and numeric labels for subjects.  See [CodeBook.md](https://github.com/krisbarrett/getting-and-cleaning-data-course/blob/master/CodeBook.md) for more information.  
- `averages.csv`: Averages all measurements from measurements.csv grouped by activity and subject. See [CodeBook.md](https://github.com/krisbarrett/getting-and-cleaning-data-course/blob/master/CodeBook.md) for more information.

## Analysis

We first read features.txt from the original dataset which contains all of the variables and their positions in the data set files.  Because we are only interested in certain variables, we use a regular expression to match the variable names that we are interested in. This gives us both the names and the positions of each variable of interest.  We also read activity_labels.txt, because it shows the mapping between numeric identifiers and a string representation of the activity.

Once we have this metadata, we read in the measurements for both the training and test data sets and perform the following: subset the data removing any columns that we are not interested in, add column for activity (including descriptive labels), and add column for subjects.  These operations are perforemed independently for the training and test data and joined together with ribind(). The resulting data frame is written to measurements.csv.

Finally, we create new data frames to calculate the averages for each variable grouped by activity and subject.  The row names of the data frames are set to the activity/subject and the averages are calculated using tapply.  The two data frames are joined together with rbind() and written to averages.csv.
