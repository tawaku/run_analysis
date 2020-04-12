run_analysis <- function() {
    # Datasets
    base_dir <- "UCI\ HAR\ Dataset"
    files <- c(
        "subject",
        "X",
        "y",
        "Inertial\ Signals/body_acc_x",
        "Inertial\ Signals/body_acc_y",
        "Inertial\ Signals/body_acc_z",
        "Inertial\ Signals/body_gyro_x",
        "Inertial\ Signals/body_gyro_y",
        "Inertial\ Signals/body_gyro_z",
        "Inertial\ Signals/total_acc_x",
        "Inertial\ Signals/total_acc_y",
        "Inertial\ Signals/total_acc_z"
    )

    # 1. Merges the training and the test sets to create one data set
    merge_dataset <- function() {
        d <- NA
        for (f in files) {
            # Read files
            train <- read.table(sprintf("%s/train/%s_train.txt", base_dir, f))
            test <- read.table(sprintf("%s/test/%s_test.txt", base_dir, f))
            # Concatenate train and test dataset
            d <- cbind(d, rbind(train, test))
        }
        # Remove NA and return data
        d[,2:ncol(d)]
    }
    
    # 4. Appropriately labels the data set with descriptive variable names
    label_dataset <- function(d) {
        # Subject
        sub <- c("subject")
        # Labels from features file
        # Remove "-, (, ), gravity*" from names and rename them into lower case
        ft_f <- read.table(sprintf("%s/features.txt", base_dir))
        ft <- tolower(gsub(",", "-", gsub("-|\\(|\\)|,gravity*", "", ft_f[[2]][!is.na(ft_f[[2]])])))
        # Remove duplication in "bands energy"
        bands_energies <- c("fbodyaccbandsenergy", "fbodyaccjerkbandsenergy", "fbodygyrobandsenergy")
        windows <- c("1-8", "9-16", "17-24", "25-32", "33-40", "41-48", "49-56", "57-64", "1-16", "17-32", "33-48", "49-64", "1-24", "25-48")
        for (b in bands_energies) {
            for (w in windows) {
                ft[!is.na(match(ft, sprintf("%s%s", b, w)))][1] <- sprintf("%sx%s", b, w)
                ft[!is.na(match(ft, sprintf("%s%s", b, w)))][1] <- sprintf("%sy%s", b, w)
                ft[!is.na(match(ft, sprintf("%s%s", b, w)))][1] <- sprintf("%sz%s", b, w)
            }
        }
        # Label (=y)
        lb <- c("label")
        # Signals
        # Name based on file name
        sig_f <- sapply(files[4:length(files)], function(x){ gsub("_", "", basename(x)) })
        sig = c()
        for (f in sig_f) {
            for (i in 1:128) {
                sig <- c(sig, sprintf("%s%s", f, i))
            }
        }
        # Return names
        c(sub, ft, lb, sig)
    }
    
    # 3. Uses descriptive activity names to name the activities in the data set
    label_act <- function(l) {
        act <- read.table(sprintf("%s/activity_labels.txt", base_dir))
        # Return converted labels
        sapply(l, function(x){ act[[2]][x] })
    }
    
    # Main
    data <- merge_dataset()
    names(data) <- label_dataset(data)
    data$label <- label_act(data$label)
    # Return
    data
}

# 2. Extracts only the measurements on the mean and standard deviation for each measurement
extract_measurement <- function(d) {
    d %>%
        dplyr::select(-c("subject", "label")) %>%
        dplyr::summarise_all(list(mean = mean, sd = sd))
}

# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
group_average <- function(d) {
    d %>%
        dplyr::group_by(label, subject) %>%
        dplyr::summarise_all(list(mean = mean))
}