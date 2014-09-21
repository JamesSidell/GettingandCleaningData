GettingandCleaningData
======================
Course Project -- Cleaning and Tidying a Data Set

The code in this repository is written to take a data set from
the link below and clean and tidy the data into a summarized
 output file.  The raw data set is obtained at this location:
 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A description of the files in this dataset can be found here:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

The goal of this analysis is to combine the two presented data sets (train, and test), clean up column and row names, merge record IDs, and generate a cleaned set of data.  This is accomplished by performing the following steps on the data:

After loading the data, the dplyr package is used to merge the columns and header names from the raw data files into the main raw numeric record file using cbind.  Some various fixes needed to be added to properly name the column variables.  This outputs a large table, from which everything but records containing measurements of mean or standard deviation were removed.  The two datasets in the raw files were then merged together using rbind.  

Since the ActivityID in the dataset was not descriptive, the activityLabels file included with the raw data set was used to rename the record entries in the ActivityID column using the descriptive name.  Mutate was used for this action.  The column variable names were then cleaned somewhat by removing non alphabetic characters that seemed useless, but fully expanding the abbreviations for the variables seemed unwise since they would become very large, and could potentially cause problems when integrating with other programs, or even just attempting to view the dataset.  gsub was used to removed various 'untidy' characters from the names.

Finally, a new table was created using ddplyr by maintaining the ActivityID and Subject group, but collapsing all other variables into the mean of the records.  This dataset is tidy because it follows the three principles of tidy data.  Each record in the data set forms its own row (an average measurement of a single subject's activity), each column contains only one variable ( an average of a single type of measurement), and the entire table contains only one observation (measurements recorded from a single type of experiment).

The tidy dataset is then modified by adding "Average " to the beginning of each column to indicate the measurements are now an average, and the tidy dataset is then exported as a csv file named "tidyData.txt"