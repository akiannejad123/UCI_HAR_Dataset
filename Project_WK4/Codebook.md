CodeBook
================

## Table of Contents

1.  Variables
2.  Transformation of information
3.  Explination of the code

# Variables

The varibles in the script and dataset are as follows:

\-Value: The Value column is a numerical observation of countinuous data
type. These observations The calculations of the mean and standard
deviation from the inertial signals dataset. These calculations have
already been performed, and are unitless.

\-Phase\_Type: This is a character observation with two nominal data,
with two catagories, value labels: testingor training. Values’ whose
corresponding rows have training as their Phase\_Type were collected in
the training phase, and those who have testing were collected in the
testing phase.

\-Signal\_Domain: This is a character observation with two nominal data
catagories, value labels: time and frequency.Values’ whose corresponding
rows in the Signal\_Domain were gathered from either captured using an
“accelerometer and gyroscope 3-axial raw signals. These time domain
signals (prefix ‘t’ to denote time) were captured at a constant rate of
50 Hz” or as part of a called a Fast Fouier Transform, (frequency).

\-Parameter\_Type: This is a character observation with two nominal data
catagories, Value Labels: gravity or body.

\-Parameter\_Type: This is a character observation with two nominal data
catagories: gravity or body.

\-Physical\_Attribute: This is a character obervation with nine nominal
data catagoies, Value Labels, as follows: Acceleration,
Acceleration\_Jerk, Gyroscope, Gyroscope\_Jerk, Acceleration\_Magnitude,
Acceleration\_Jerk\_Magnitude, Gyroscope\_Magnitude,
Gyroscope\_Jerk\_Magnitude, and Acceleration\_Jerk

\-Parameter\_Statistic: This is a character observation with two nominal
data catagories, Value Labels: std and mean. The Value label std was
transformed to the whole word standard\_deviation. In the original file
features.txt there were other types of means, such as gravityMean and
meanFrequency. THose were eliminated because the term mean was
interperted in its strictest sense, as in mean only.

\-Axis: This is a character observation with four nominal data
catagories, Value Labels: X, Y, Z, NA. These denote which axis the mean
or standard deviation were calculated from using the inertial signal
data. The NA was introduced for those signals that were not taken from
an axis.

\-Activity\_Name: This is a character observation with six nominal data
catagories, Value Labels: Walking, Walking\_Upstairs,
Walking\_downstairs, Sitting, Standing, Laying

\-Subject\_Number: This is a character observation with thirty nominal
data catagories, Value\_Labels:1-30, representing the value assigned by
the researchers to the subjects during the training and testing phases.

\-Activity\_Value This is a character observation (not numeric) with six
catagories which correspond to the Activity\_Name variables, Value
Labels: 1:Walking, 2:Walking\_Upstairs: 3:Walking\_downstairs,
4:Sitting, 5:Standing, 6:Laying.

\-Activity\_Counts: This is a character observation (converted from
numeric, see part2), denoting how many times an
Activity\_Name/Activity\_Value was observed during the two phases, Value
Labels:1-100.

## Transformation of the Varibles from Orginal Files to Run\_Analysis\_dataset

1.) The orginal information was given as a series of text files To be
used for both sets: features.txt activity\_labels.txt For training only:
subject\_train.txt x\_train.txt y\_train.txt For testing only:
subject\_test.txt x\_test.txt y\_test.txt

The dimensions of the activity\_label.txt files has 6 observations and 2
variables due to the introduction of a space upon reading. It was dealt
with by dropping the V1

The dimensions of the feature.txt read in as Study\_features dataframe
561 observations and 1 variable

Then transformed to as a vector Features

The dimensions of the x\_train.txt read in as Study\_x\_train dataframe
and has 7352 observations and 561 variables

The dimensions of the y\_train.txt read in as Study\_y\_train dataframe
and has 7352 observations and 1 variable.

The dimensions of the subject\_train read in as Study\_Subject\_training
and has 7352 observations and 2 variables.

The dimensions of the x\_train.txt read in as Study\_x\_test dataframe
and has 2947 observations and 561 variables.

The dimensions of the y\_train.txt read in as Study\_y\_test dataframe
and has 2947 observations and 1 variable.

The dimensions of the Subject\_test read in as Study\_Subject\_testing
and has 2947 observations and 2 variables.

2.) From these files they were read as deliminated files in to R.

3.) From the original files: activity\_label files and y\_train files
were joined together For the training portion of the data and adding
descriptive labs to the y training set.

The Study\_features dataframe was transformed by separating parts of the
Feature names into its various parts to make to take the V2 from
Physical\_Parameter to Parameter\_Statistic and Axis

4.) The Value column requires no calculation to be made on it. As it is
the Mean or standard\_deviation of the Interial Signal not used in this
data set. No further calculations were required.

5.) The final dataset of the merged test and train files was called
Merged\_training\_and\_testing\_dataframe then exported as a text
filevcalled Run\_analysis dataset. It was exported as a .txt file and is
separated by commas.
