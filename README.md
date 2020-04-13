# run_analysis
Create tidy data set from 'UCI HAR Dataset.zip'.

## Available datasets
'run_analysis.R' Generates following data sets:

| No. | Data set | Overview | Function to use | Input for function |
|--|--|--|--|--|
|ds1-1|Training/Test Data Set|One data set created by merging the training and the test sets|run_analysis|None|
|ds1-2|Mean/Standard Deviation Data Set|Extracts the measurements on the mean and standard deviation|extract_measurement|Training/Test Data Set|
|ds2|Group AVG Data Set|Data set with the average of each variable for each activity and each subject|group_average|Training/Test Data Set|

CSV data set files corresponding to 'No.' are included in this repository.

## How to use run_analysis.
1. Unzip 'UCI HAR Dataset.zip' in the same directory as 'run_analysis.R'.
1. Load 'run_analysis.R.

    ```R
    source("run_analysis.R")
    ```

1. Merges the training and the test sets to create one data set.

    ```R
    data <- run_analysis()
    ```

1. Extracts only the measurements on the mean and standard deviation for each measurement.

    ```R
    extract_measurement(data)
    ```

1. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

    ```R
    group_average(data)
    ```
