# READ TRAINING DATA FROM THE IMPORTED FILES
traindata_x <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//train//X_train.txt")
traindata_y <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//train//y_train.txt") 
traindata_subject <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//train//subject_train.txt") 

# READ TEST DATA FROM THE IMPORTED FILES 
testdata_x <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//test//X_test.txt") 
testdata_y <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//test//y_test.txt") 
testdata_subject <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//test//subject_test.txt") 
 
# READ THE FEATURES DOCUMENT
features <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//features.txt") 
 
# READ THE ACTIVITY LABELS
activity_labels <- read.table("C://Users//u182335//Documents//DataScience//DataCleaningAssignment//activity_labels.txt") 
 
# MERGE THE DATA 
joined_data <- rbind(traindata_x,testdata_x) 
joined_labels <- rbind(traindata_y,testdata_y) 
joined_subjects <- rbind(traindata_subject,testdata_subject) 
 
# SET COLUMN NAMES  
names(joined_data) = features[[2]] 
names(joined_labels) = c("activityid") 
names(joined_subjects) = c("subjects") 

# MERGE THE TWO VECTORS AND REMOVE ANY DUPES
means_indices <- grep("mean",features[[2]]) 
std_indices <- grep("std",features[[2]]) 
merged_indices <- unique(c(means_indices,std_indices)) ## Use unique to remove any duplicates if any 

# EXTRACT MERGED DATA FROM INDICES 
joined_data_b <- joined_data[merged_indices]

# CLEANSE DATA 
names(activity_labels) = c("activityid","activityname") 

# SUBSTITUDE IDS  
activities <- merge(activity_labels,joined_labels,"activityid") 
joined_data_b$activities <- activities[[2]] 
joined_data_b$subjects <- joined_subjects[[1]] 

# CLEANSE NAMING CONVENTION
names(joined_data_b) <- gsub("\\(\\)","",names(joined_data_b)) 
names(joined_data_b) <- gsub("std","Std",names(joined_data_b)) 
names(joined_data_b) <- gsub("mean","Mean",names(joined_data_b)) 
names(joined_data_b) <- gsub("-","",names(joined_data_b)) 

# CREATE THE TIDY DATASET
second_dataset <- aggregate(joined_data_b, by=list(activity = joined_data_b$activities, subject=joined_data_b$subjects), mean) 
 
# WRITE CLEANSED DATA TO NEW TABLE 
write.table(joined_data_b, "C://Users//u182335//Documents//DataScience//DataCleaningAssignment//test//clean_data.txt") 
write.table(second_dataset,"C://Users//u182335//Documents//DataScience//DataCleaningAssignment//test//second_dataset.txt",row.name=FALSE)

