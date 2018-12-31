library(reshape)
library(reshape2)

# ------------------- Now let's read in our newly downloaded data ------------- #
# Let's read in the features and activity data
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

# Let's read in the trainining data
# Loading in the training features data
training_set <- read.table("./UCI HAR Dataset/train/X_train.txt") 

# Lets make sure to add descriptive column names for the data 
# so this is readable to other parties
colnames(training_set) <- features$V2 
# Loading in the training activity labels
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
training_set$activity <- y_train$V1
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
training_set$subject <- factor(subject_train$V1)


# Reading in the test data
test_set <- read.table("./UCI HAR Dataset/test/X_test.txt")
colnames(test_set) <- features$V2
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") 
test_set$activity <- y_test$V1
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
test_set$subject <- factor(subject_test$V1)

# Step 1: We merge the training and test sets
merged_dataset <- rbind(test_set, training_set) 

# Step 2: We filter the column names
column.names <- colnames(merged_dataset)

# Only keep columns for standard deviation (std) and mean values
# We will then save the activity and subject values 
column.names.filtered <- grep("std\\(\\)|mean\\(\\)|activity|subject", column.names, value=TRUE)
merged_dataset.filtered <- merged_dataset[, column.names.filtered] 

# Step 3: We need to have/add descriptive values for activity labels so it can be widely understood
merged_dataset.filtered$activitylabel <- factor(merged_dataset.filtered$activity, labels= c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))

# Create the tidy dataset with mean values for each subject and activity
features.colnames = grep("std\\(\\)|mean\\(\\)", column.names, value=TRUE)
merged_dataset.melt <-melt(merged_dataset.filtered, id = c('activitylabel', 'subject'), measure.vars = features.colnames)
merged_dataset.tidy <- dcast(merged_dataset.melt, activitylabel + subject ~ variable, mean)

# Writing out the tidy dataset file, and saving it as "tidy_data.txt"
write.table(merged_dataset.tidy, file = "tidy_data.txt", row.names = FALSE)