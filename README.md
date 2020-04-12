# run_analysis

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
