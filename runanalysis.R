#load working directory
setwd("~/projectfile/UCI HAR Dataset")
list.files()
#reading training table
xtrain = read.table("X_train.txt", header = FALSE)
ytrain = read.table("y_train.txt", header = FALSE)
subject_train = read.table("subject_train.txt", header = FALSE)
#reading test table
xtest = read.table("x_test.txt", header = FALSE)
ytest = read.table("y_test.txt", header = FALSE)
subject_test = read.table("subject_test.txt", header = FALSE)
#reading features
features = read.table("features.txt", header = FALSE)
#reading activity
activitylabels = read.table("activity_labels.txt", header = FALSE)
#creating column for trainset
colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subject_train) = "subjectId"
#creating column for testset
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subject_test) = "subjectId"

colnames(activitylabels) <- c("activityId","activityType")
#merging
mrg_train <- cbind(xtrain, subject_train, ytrain)
mrg_test <- cbind(xtest, subject_test, ytest)
altogether <- rbind(mrg_train, mrg_test)
#extraction
colNames = colnames(altogether)
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl(
  "mean.." , colNames) | grepl("std.." , colNames))
setForMeanAndStd <- altogether[ , mean_and_std == TRUE]
setWithActivityNames = merge(mean_and_std, activitylabels)
#create new tidy set
secTidySet <- aggregate(.~+ activityId, setWithActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$activityType, secTidySet$activityId),] 
#save
write.table(secTidySet, "secTidySet.txt", row.name=FALSE)