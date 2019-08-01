## Project Description

The purpose of this project is to demonstrate the ability to collect,
work with, and clean a data set. The goal is to prepare tidy data that
can be used for later analysis.

The required submissions include the following:

1.  a tidy data set as described below,
2.  a link to a Github repository with a script for performing the
    analysis (the github repository for this project is found at
    [www.github.com/](www.github.com/),
3.  a code book called CodeBook.md that describes the variables, the
    data, and any transformations or work that was performed to clean up
    the data.
4.  a README.md in the repo with the scripts; this repo explains how the
    scripts work and how they are connected.

## Data Source

The dataset downloaded for cleaning was the Human Activity Recognition
Using Smartphones Dataset, Version 1.0, via the link to in the Coursera
materials
\[**here**\].(<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>)

My R script(run\_analysis.R) does the following:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation
    for each measurement.
3.  Uses descriptive activity names to name the activities in the data
    set
4.  Appropriately labels the data set with descriptive variable names.
5.  From the data set in step 4, creates a second, independent tidy data
    set with the average of each variable for each activity and each
    subject.

### Merging the training and the test sets to create one data set

The test and training datasets are spread out over 6 files: y\_test.txt,
X\_test.txt, subject\_test.txt, and y\_train.txt, X\_train.txt,
subject\_train.txt. My script loads all these files into dataframes
using the read.delim() function, then merges all the test data together
into `test_data`. The training data is merged into dataframe called
`train_data`. The dimensions of the dataframes created are as follows:

  - **y\_test :** 2,947 observations(rows) and 1 column with numbered
    label (1-6) for activity of experimental subjects. There are 9
    subjects (2, 4, 9, 10, 12, 13, 18, 20, and 24) included vs. a total
    of 30, so 30% of the data were for test data set and the remaining
    21 subjects (70%) were part of the training set.  

  - **subject\_test :** 2,947 rows x 1 column with numbered label (1-30)
    of subject who performed the activity

  - **X\_test :** 2,947 observations(rows) x 562 columns(1 index column
    to use for merging, and 561 feature variables). For each subject,
    two experiments were run, each of about 163 rows (i.e., 163 rows x 9
    subjects x 2 experiments = 2,934 total rows). Due to sampling and
    how the experiments were manually labeled, the samples or rows are
    not exactly the same from experiment to experiment. Features are
    normalized and bounded within \[-1,1\].

  - **y\_train :** 7,352 rows x 1 column.

  - **subject\_train :** 7,352 rows x 1 column, with numbered label
    (1-30) of subject who performed the activity.

  - **X\_train :** 7,352 rows x 562 columns. There were 21 subjects
    included in this dataset, each with 2 experiments, which comes to
    about 175 samples(or rows) per experiment. Features are normalized
    and bounded within
\[-1,1\].

`all_data`

| Index                           | Subject | y\_numlabels | Activity | 561 variables |
| ------------------------------- | :-----: | :----------: | :------: | :-----------: |
| Total 10,299 rows x 565 columns |         |              |          |               |

### Extracting only the measurements on the mean and standard deviation for each measurement

The `str_detect` function is used to find which of the 561 features in
the X\_train and X\_test files have the string “mean” or “std”. Then the
`select` function from the plyr library is used to select only those
columns from `all_data`, in addition to activity and index and subject
columns, and create a new dataframe
`extracted_data`.

| Index                          | Activity | Subject | 46 mean variables | 33 standard deviation variables |
| ------------------------------ | :------: | :-----: | :---------------: | :-----------------------------: |
| Total 10,299 rows x 82 columns |          |         |                   |                                 |

### Using descriptive activity names to name the activities in the data set

Each subject/person performed six activities during the experiment
(WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING,
LAYING). To transform the number label for each activity into its
descriptive label, the script loads the activity\_labels.txt into the
dataframe ***activity***. An anonymous function `label_function` is used
to lookup the descriptive label from this dataframe and then transforms
the ***activity*** column of the `all_data` dataframe from its
initialized value to the correct descriptive label.

### Appropriately labeling the data set with descriptive variable names

The features.txt file provides variable names which are sufficiently
descriptive. `names(X_test)<-t(features[,2])` assigns the column names
of the X\_test to those features, which were loaded into the variable
`features`. The same applies to X\_train. Then, to improve readability,
the run\_analysis.R script removes ‘()’ characters from the variable
names and replaces hyphens(-) with an underscore character(\_), using
the `gsub`
function.

### Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

The extracted tidy data set is stored in the variable
`mean_by_activity`. This is derived from `extracted_data`, which is the
variable that stores the merged test and training
data.

| Index                       | Activity | Subject | 46 mean variables | 33 standard deviation variables |
| --------------------------- | :------: | :-----: | :---------------: | :-----------------------------: |
| Total 180 rows x 82 columns |          |         |                   |                                 |
