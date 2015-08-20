setwd("C:/zzCoursera/Module3/Coursework")
library(plyr)

# Step 1
# Merge the training and test sets to create one data set
###############################################################################

#read source x_train, y_train, subject_train 
x_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
subject_train <- read.table("subject_train.txt")

#read source x_test, y_test, subject_test 
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subject_test <- read.table("subject_test.txt")

# create 'a' data set
a_dat <- rbind(x_train, x_test)

# create 'b' data set
b_dat <- rbind(y_train, y_test)

# create 'subject' data set
subject_dat <- rbind(subject_train, subject_test)

# Step 2
# Extract only the measurements on the mean and standard deviation for each measurement
###############################################################################

features <- read.table("features.txt")

# grep only columns with mean() or std() in their names
meanstd_features <- grep("-(mean|std)\\(\\)", features[, 2])

# calculate means and standard columns
a_dat <- a_dat[, meanstd_features]

# rename column names
names(a_dat) <- features[meanstd_features, 2]

# Step 3
# Use descriptive activity names to name the activities in the data set
###############################################################################

activities <- read.table("activity_labels.txt")

# update values with correct activity names
b_dat[, 1] <- activities[b_dat[, 1], 2]

# correct column name to acitivity
names(b_dat) <- "activity"

# Step 4
# Appropriately label the data set with descriptive variable names
###############################################################################

# correct column name to subject
names(subject_dat) <- "subject"

# bind all the data in a single data set
all_dat <- cbind(a_dat, b_dat, subject_dat)

# Step 5
# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
###############################################################################

avg_dat <- ddply(all_dat, .(subject, activity), function(x) colMeans(x[, 1:100]))

write.table(avg_dat, "Tidy.txt", row.name=FALSE)

