README
================

`{r setup, include=FALSE} knitr::opts_chunk$set(echo = FALSE)`

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

4.) The Study\_features dataframe was transformed by separating parts of
the Feature names into its various parts to make to take the V2 from
Physical\_Parameter to Parameter\_Statistic and Axis

5.) The Variable Activity\_Counts was created to make a unique column
labels.

5.) The Value column requires no calculation to be made on it. As it is
the Mean or standard\_deviation of the Interial Signal not used in this
data set. No further calculations were required.

5.) The final dataset of the merged test and train files was called
Merged\_training\_and\_testing\_dataframe then exported as a text
filevcalled Run\_analysis dataset. It was exported as a .txt file and is
separated by commas.
