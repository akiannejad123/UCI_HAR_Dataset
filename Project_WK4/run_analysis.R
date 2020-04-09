library(tidyverse)
library(data.table)

#####
#this is will need to be changed to downloading file later
setwd("C:/Users/sherw/OneDrive/Desktop/gettingdata/UCI_HAR_Dataset")
#setwd("E:/UCI_HAR_Dataset")
##########
#load activity_label file for both training and testing files
activity_file <-read.delim("activity_labels.txt", header=FALSE, sep=" ", stringsAsFactors = FALSE)
# Give the Activity file appropriate readable column names
  colnames(activity_file)<- c("Value", "Activity")

  
# Load Study features 
#this will be used in both the test and training files.
Study_features <-read.delim("features.txt", header=FALSE, sep= "", stringsAsFactors = FALSE)
#Drop the value column so that Study features can be column labels for x train
Study_features <-Study_features%>%
   select(-V1) # must be dropped to make Study features a vector for column labelling

#create a vector to be used as column labels in  the x_train and x_test files
Features <-as.vector(as.character(Study_features$V2))

#first we load the training information 
Study_x_train <- read.delim("train/x_train.txt",header=FALSE, sep="",stringsAsFactors = FALSE )
  colnames(Study_x_train) <-Features
Study_y_train <- read.delim("train/y_train.txt",header=FALSE, sep="", stringsAsFactors= FALSE)
  colnames(Study_y_train) <-c("Value") # This is the first file unique to the test set

#Being consistant we now load in the test sets with same names as with the training set
  
Study_x_test <- read.delim("test/x_test.txt",header=FALSE, sep="",stringsAsFactors = FALSE )
  colnames(Study_x_test) <-Features
Study_y_test <- read.delim("test/y_test.txt",header=FALSE, sep="", stringsAsFactors= FALSE)
  colnames(Study_y_test) <-c("Value")
  
# Reading in the Subject training information 
Study_Subject_training <-read.delim("train/subject_train.txt", header=FALSE, sep="", stringsAsFactors =FALSE)
# Add an appropriate Column name suitible for both the training and testing files to merge on
  colnames(Study_Subject_training) <- c("Subject_Number")
# Reading in the Subject training information 

  # Reading in the Subject information 
Study_Subject_testing <-read.delim("test/subject_test.txt", header=FALSE, sep="", stringsAsFactors =FALSE)
  colnames(Study_Subject_testing) <-c("Subject_Number")
  
  
# Here a code break point will be used for readability
######################################################################
#Everything will be first performed on test set then the training with "train and test" 
#to differentiate between the two
  
  
#### For the training portion of the data
# adding descriptive labs to the y training set
Study_y_train_with_activity_labels <-inner_join(Study_y_train, activity_file, by="Value")
    colnames(Study_y_train_with_activity_labels) <-c("Activity_Value", "Activity_Name")

# adding descriptive labs to the y test set
Study_y_test_with_activity_labels <-inner_join(Study_y_test, activity_file, by="Value")
  colnames(Study_y_test_with_activity_labels) <-c("Activity_Value", "Activity_Name")
#Now the Study_y_train_with_activity_labels needs
#to be joined columnwise to the Study_x_train containing Feature headers
# This still does not contain Subject data

#Now the Study_y_test_with_activity_labels needs
#to be joined columnwise to the Study_x_test containing Feature headers
# This still does not contain Subject data
Activity_labels_and_features_testing_dataframe <-cbind(Study_y_test_with_activity_labels, Study_x_test)
#Adding Subject information to the dataframe
Subject_Activity_and_features_testing_dataframe <-cbind(Study_Subject_testing,Activity_labels_and_features_testing_dataframe)
#We need to add a column named Phase type all rows containing the char"Training
# This designates training from testing
#First make the vector containing the information

Activity_labels_and_features_training_dataframe <-cbind(Study_y_train_with_activity_labels, Study_x_train)
#Adding Subject information to the  activity and feature training dataframe
Subject_Activity_and_features_training_dataframe <-cbind(Study_Subject_training,Activity_labels_and_features_training_dataframe)

# we load all of the test sets to be evaluated 
#########################################################


#Binding columnwise to the training set

# select for column names that have only Std() and mean()
Subject_Activity_and_features_testing_dataframe <-data.frame(Subject_Activity_and_features_testing_dataframe)

Subject_Activity_and_features_training_dataframe <-data.frame(Subject_Activity_and_features_training_dataframe)


###################################




Subject_Activity_and_features_testing_dataframe_2<-Subject_Activity_and_features_testing_dataframe%>%
  select(matches("mean|std"))%>%
  select(-(matches("gravityMean", ignore.case=TRUE)))%>%
  select(-(matches("meanFreq", ignore.case = TRUE)))%>%
  select(-(matches("angle", ignore.case = TRUE)))
Activity_Selection_for_testing <-colnames(Subject_Activity_and_features_testing_dataframe_2)


Subject_Activity_and_features_training_dataframe_2<-Subject_Activity_and_features_training_dataframe%>%
  select(matches("mean|std"))%>%
  select(-(matches("gravityMean", ignore.case=TRUE)))%>%
  select(-(matches("meanFreq", ignore.case = TRUE)))%>%
  select(-(matches("angle", ignore.case = TRUE)))



Activity_Selection_for_training <-colnames(Subject_Activity_and_features_training_dataframe_2)


#Activity_Selection <-data.frame(Activity_Selection)
#colnames(Activity_Selection) <-c("Full_Parameters")
#Activities_Separated <-Activity_Selection%>%
#  separate(Full_Parameters,c("Parameter", "Parameter_Statistic", "Axis_or_Angle", if.blank=NA))


Decomposed_Features_for_testing <- data.frame(colnames(Subject_Activity_and_features_testing_dataframe_2))
  colnames(Decomposed_Features_for_testing) <-c("V2")


Decomposed_Features_for_training <- data.frame(colnames(Subject_Activity_and_features_training_dataframe_2))
  colnames(Decomposed_Features_for_training) <-c("V2")


#this separates the Phsycial parameters into their elemental parts 

Decomposed_Features_for_testing<-Decomposed_Features_for_testing%>%
  separate(V2,c( "Physicial_Parameter", "Parameter_Statistic", "Axis" ))


Decomposed_Features_for_training <-Decomposed_Features_for_training%>%
  separate(V2,c( "Physicial_Parameter", "Parameter_Statistic", "Axis" ))


# NA need to be added to any place that the Axis label is blank 

########################################################

Decomposed_Features_for_testing <-Decomposed_Features_for_testing%>%
  mutate_at(.vars = c("Parameter_Statistic","Axis"),
            .funs = list(~ifelse(.=="", NA, as.character(.))))



a = gsub('(t|f)(Body|Gravity)',
         '\\1|\\2|\\3',Decomposed_Features_for_testing$Physicial_Parameter) 

do.call(rbind, strsplit(a,'[|]') )

Decomposed_Features_for_testing_split <- cbind(Decomposed_Features_for_testing,do.call(rbind,strsplit(a,'[|]'))) 
colnames(Decomposed_Features_for_testing_split)[4:6] = c ("Signal_Domain" , "Parameter_Location", "Physical_Attribute")

Decomposed_Features_for_testing_split <-data.frame(Decomposed_Features_for_testing_split)

################################################

Decomposed_Features_for_training <-Decomposed_Features_for_training%>%
  mutate_at(.vars = c("Parameter_Statistic","Axis_or_Angle"),
            .funs = list(~ifelse(.=="", NA, as.character(.))))


b = gsub('(t|f)(Body|Gravity)',
         '\\1|\\2|\\3',Decomposed_Features_for_training$Physicial_Parameter) 

do.call(rbind, strsplit(b,'[|]') )

Decomposed_Features_for_training_split <- cbind(Decomposed_Features_for_training,do.call(rbind,strsplit(b,'[|]'))) 
colnames(Decomposed_Features_for_training_split)[4:6] = c ("Signal_Domain" , "Parameter_Location", "Physical_Attribute")

Decomposed_Features_for_training_split <-data.frame(Decomposed_Features_for_training_split)
###############################################
#### 
#Make components more legible 
Decomposed_Features_for_training_split$Signal_Domain <-recode(Decomposed_Features_for_training_split$Signal_Domain, "f"="frequency")

Decomposed_Features_for_training_split$Signal_Domain <-recode(Decomposed_Features_for_training_split$Signal_Domain, "t"="time")


Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "Acc"="Acceleration")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "AccJerk"="Acceleration_Jerk")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "GyroJerk"="Gyroscope_Jerk")


Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "Gyro"="Gyroscope")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "AccMag"="Acceleration_Magnitude")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "GyroMag"="Gyroscope_Magnitude")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "GyroJerkMag"="Gyroscope_Jerk_Magnitude")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "AccJerkMag"="Acceleration_Jerk_Magnitude")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "BodyGyroJerkMag"="Body_Gyroscope_Jerk_Magnitude")

Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "BodyGyroMag"="Body_Gyroscope_Magnitude")
Decomposed_Features_for_training_split$Physical_Attribute <-recode(Decomposed_Features_for_training_split$Physical_Attribute, "BodyAccJerkMag"="Body_Acceleration_Jerk_Magnitude")
Decomposed_Features_for_training_split$Parameter_Statistic<-recode(Decomposed_Features_for_training_split$Parameter_Statistic, "std"="standard_deviation" )

###################################################################################
#Make components more legible 
Decomposed_Features_for_testing_split$Signal_Domain <-recode(Decomposed_Features_for_testing_split$Signal_Domain, "f"="frequency")

Decomposed_Features_for_testing_split$Signal_Domain <-recode(Decomposed_Features_for_testing_split$Signal_Domain, "t"="time")


Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "Acc"="Acceleration")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "AccJerk"="Acceleration_Jerk")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "GyroJerk"="Gyroscope_Jerk")


Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "Gyro"="Gyroscope")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "AccMag"="Acceleration_Magnitude")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "GyroMag"="Gyroscope_Magnitude")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "GyroJerkMag"="Gyroscope_Jerk_Magnitude")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "AccJerkMag"="Acceleration_Jerk_Magnitude")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "BodyGyroJerkMag"="Body_Gyroscope_Jerk_Magnitude")

Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "BodyGyroMag"="Body_Gyroscope_Magnitude")
Decomposed_Features_for_testing_split$Physical_Attribute <-recode(Decomposed_Features_for_testing_split$Physical_Attribute, "BodyAccJerkMag"="Body_Acceleration_Jerk_Magnitude")
Decomposed_Features_for_testing_split$Parameter_Statistic<-recode(Decomposed_Features_for_testing_split$Parameter_Statistic, "std"="standard_deviation" )
####################################################

#####################
#transposing the dataframes to add the decomposed_feature information as rowa

Subject_Activity_and_features_testing_dataframe_transpose <-transpose(Subject_Activity_and_features_testing_dataframe_2)
Subject_Activity_and_features_training_dataframe_transpose <-transpose(Subject_Activity_and_features_training_dataframe_2)

###########
Features_and_transpose_Combined_training <-cbind(Decomposed_Features_for_training_split, 
         Subject_Activity_and_features_training_dataframe_transpose)
Features_and_transpose_Combined_testing <- cbind(Decomposed_Features_for_testing_split,
         Subject_Activity_and_features_testing_dataframe_transpose)


Subject_with_y_test_and_activity_Labels <-cbind(Study_Subject_testing, 
        Study_y_test_with_activity_labels)
Subject_with_y_training_and_activity_Labels <-cbind(Study_Subject_training, 
        Study_y_train_with_activity_labels)


Study_Subject_testing <-data.frame(Study_Subject_testing)
Study_Subject_training <-data.frame(Study_Subject_training)


Study_Subject_testing[,"Activity_Counts"]<-NA
Study_Subject_training[,"Activity_Counts"]<-NA


Subject_y_testing_with_activity_labels<- cbind(Study_Subject_testing,Study_y_test_with_activity_labels )
Subject_y_training_with_activity_labels<- cbind(Study_Subject_training,Study_y_train_with_activity_labels )
#################################################3

Subject_y_training_with_activity_labels<-Subject_y_training_with_activity_labels%>%
    group_by(Subject_Number, Activity_Name) %>% #Grouping 
      #summarise(count = n()) %>% #Performing the count
    mutate( Activity_Counts= seq((Subject_Number)))%>%
    select("Activity_Name", "Subject_Number", "Activity_Counts", "Activity_Value")

Subject_y_testing_with_activity_labels<-Subject_y_testing_with_activity_labels%>%
    group_by(Subject_Number, Activity_Name) %>% #Grouping 
      #summarise(count = n()) %>% #Performing the count
    mutate( Activity_Counts= seq((Subject_Number)))%>%
    select("Activity_Name", "Subject_Number", "Activity_Counts", "Activity_Value")


# Gathering all the Activity and Subject iformation for a Row of unique values
Gathered_Labels_Subject_Activity_Occurences_testing <- Subject_y_testing_with_activity_labels%>%
  unite("Combined_Names", "Activity_Name", "Subject_Number", "Activity_Counts", "Activity_Value", sep=".")

Gathered_Labels_Subject_Activity_Occurences_training <- Subject_y_training_with_activity_labels%>%
  unite("Combined_Names", "Activity_Name", "Subject_Number", "Activity_Counts", "Activity_Value", sep=".")

Gathered_Labels_training <-as.vector(Gathered_Labels_Subject_Activity_Occurences_training$Combined_Names)
Gathered_Labels_testing  <-as.vector(Gathered_Labels_Subject_Activity_Occurences_testing$Combined_Names)




Features_and_transpose_Combined_name_training <-c("Physical_Parameter", "Parameter_Statistic",
                    "Axis","Signal_Domain",  "Parameter_Type", "Physical_Attribute")
Colnmes_1_training<-c(Features_and_transpose_Combined_name_training, Gathered_Labels_training)
Colnmes_1_training<-as.vector(Colnmes_1_training)


Features_and_transpose_Combined_name_testing <-c("Physical_Parameter", "Parameter_Statistic",
                    "Axis","Signal_Domain",  "Parameter_Type", "Physical_Attribute")


Colnmes_1_testing<-c(Features_and_transpose_Combined_name_testing, Gathered_Labels_testing)
Colnmes_1_testing<-as.vector(Colnmes_1_testing)


colnames(Features_and_transpose_Combined_training) <-Colnmes_1_training
colnames(Features_and_transpose_Combined_testing) <- Colnmes_1_testing












Features_and_transpose_Combined_training_2 <- gather(Features_and_transpose_Combined_training, "code",
         Subject_with_y_training_and_activity_Labels, 7:7358 )
dim(Features_and_transpose_Combined_training_2)
Features_and_transpose_Combined_testing_2 <-  gather(Features_and_transpose_Combined_testing, "code",
         Subject_with_y_test_and_Activity_Labels, 7:2953 )
# Changing the 
colnames(Features_and_transpose_Combined_training_2)[8] <-"Value"
colnames(Features_and_transpose_Combined_testing_2)[8] <-"Value"

Features_and_transpose_Combined_training_3 <- separate(Features_and_transpose_Combined_training_2, 
          code,c("Activity_Name", "Subject_Number", "Activity_Counts", "Activity_Value"), sep="[\\.]" )
Features_and_transpose_Combined_testing_3  <- separate(Features_and_transpose_Combined_testing_2,
          code, c("Activity_Name", "Subject_Number", "Activity_Counts", "Activity_Value"), sep="[\\.]")
#We need to add a column named Phase type all rows containing the char"Training
# This designates training from testing
#First make the vector containing the information

# 
Complete_Combined_training_3<-cbind(Phase_Type="Training", Features_and_transpose_Combined_training_3)
Complete_Combined_testing_3 <-cbind(Phase_Type="Testing",  Features_and_transpose_Combined_testing_3)






Merged_training_and_testing_dataframe <-rbind(Complete_Combined_training_3,Complete_Combined_testing_3)
Merged_training_and_testing_dataframe<-data.frame(Merged_training_and_testing_dataframe)%>%
  select(Phase_Type,Signal_Domain,Parameter_Type, Physical_Attribute, Axis,Parameter_Statistic,
         Activity_Name, Subject_Number, Activity_Counts, Activity_Value, Value )

# some columns have been changed to factors to characters

Merged_training_and_testing_dataframe%>% 
  mutate_if(is.factor, as.character)-> Merged_training_and_testing_dataframe

Merged_training_and_testing_dataframe <-data.frame(Merged_training_and_testing_dataframe)


write.csv(Merged_training_and_testing_dataframe, "run_analysis_dataset.txt", row.names = FALSE )
#######################
#REorganizing Study_x_test 
# in a more cohesive data table
