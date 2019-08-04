Project Description
-------------------

The purpose of this project is to demonstrate the ability to collect,
work with, and clean a data set. The goal is to prepare tidy data that
can be used for later analysis.

The required submissions include the following:

1.  a tidy data set submitted as a text file,
2.  a link to a Github repository with a script for performing the
    analysis (the github repository for this project is found at
    <https://github.com/pjrowe/Get_and_Clean_Data_Week4/>),
3.  a code book called CodeBook.md that describes the variables, the
    data, and any transformations or work that was performed to clean up
    the data,
4.  a README.md in the repo which explains how the scripts work and how
    they are connected.

Data Source
-----------

The dataset downloaded for cleaning was the Human Activity Recognition
Using Smartphones Dataset, Version 1.0, via the link to in the Coursera
materials
\[**here**\].(<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" class="uri">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>).
The download process was automated in the R script.

README: How the Script Works
----------------------------

There is only one script file - run\_analysis.R. It does the following
tasks, which are explained in more detail in the headings below:

1.  Merges the training and the test sets to create one data set.
2.  Extracts only the measurements on the mean and standard deviation
    for each measurement.
3.  Uses descriptive activity names to name the activities in the data
    set
4.  Appropriately labels the data set with descriptive variable names.
5.  From the data set in step 4, creates a second, independent tidy data
    set with the average of each variable for each activity and each
    subject.

### 1. Merging the training and the test sets to create one data set

The test and training datasets are spread out over the 6 files bulleted
below. My script loads all these files into dataframes using the
read.delim() function, adds an index column to the dataframes, and then
performs two separate merges on the index columns: first, to connect the
‘y’ and ‘subject’ dataframes, and second, to add on the ‘x’ variables.
These two merges are done for both the training and test data sets. We
should also note that the X dataframes are given descriptive variable
names from the features.txt file.

The dataframes `test_data` and `train_data` are then combined into
all\_data using rbind(). The `all_data` dataframe has 10,299 rows x 564
columns (rows = combined rows of test and training data, columns =
index, subject, y\_numlabels, 561 feature variables).

-   **y\_test :** 2,947 observations(rows) and 1 column with a number
    label (1-6) for the activity performed by the experimental subjects.
    There are 9 subjects (2, 4, 9, 10, 12, 13, 18, 20, and 24) included
    vs. a total of 30, so 30% of the data were for the test data set and
    the remaining 21 subjects (70%) were part of the training set.  
-   **subject\_test :** 2,947 rows x 1 column with numbered label (1-30)
    of subject who performed the activity.
-   **X\_test :** 2,947 observations(rows) x 561 columns of feature
    variables. For each subject, two experiments were run, each of about
    163 rows (i.e., 163 rows x 9 subjects x 2 experiments = 2,934 total
    rows). Due to sampling and how the experiments were manually
    labeled, the samples or rows are not exactly the same from
    experiment to experiment. Features are normalized and bounded within
    \[-1,1\].

-   **y\_train :** 7,352 rows x 1 column.
-   **subject\_train :** 7,352 rows x 1 column, with numbered label
    (1-30) of subject who performed the activity.
-   **X\_train :** 7,352 rows x 561 columns. There were 21 subjects
    included in this dataset, each with 2 experiments, which comes to
    about 175 samples(or rows) per experiment. Features are normalized
    and bounded within \[-1,1\].

An overview of the 561 feature variables in X\_train, X\_test, and
all\_data can be found at the bottom of this document, but because most
are excluded from the tidy data set and are not transformed in any way,
we will not provide a full description of all 561. The names of the 79
variables (46 mean variables and 33 standard deviation variables) that
end up in the mean\_by\_activity tidy data set are are included in the
Appendix, however.

### 2. Extracting only the measurements on the mean and standard deviation for each measurement

The `str_detect` function is used to find which of the 561 features in
the X\_train and X\_test files contain the string “mean” or “std”. Then
the `select` function from the plyr library is used to select only those
columns from `all_data`, in addition to index, y\_numlabel(numbered
activity label), and subject columns. The resulting dataframe is
`extracted_data` and has 10,299 rows x 82 columns. We use gsub() command
to remove () characters from the variable names, and substitute ’\_" for
hyphens.

| index | y\_numlabels | subject | 46 mean variables | 33 standard deviation variables |
|-------|:------------:|:-------:|:-----------------:|:-------------------------------:|
|       |              |         |                   |                                 |

### 3. Using descriptive activity names to name the activities in the data set

Each subject/person performed six activities during the experiment
(WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING,
LAYING). To transform the number label for each activity (y\_numlabell)
into its descriptive label, the script loads the activity\_labels.txt
into the dataframe ***activity***. We insert a column named ‘activity’
into the extracted\_data dataframe after the ‘y\_numlabels’ column and
initialize with a placeholder sequence, and then use the function
`label_function` to lookup the descriptive label from the activity
dataframe and transform the ***activity*** column of the
`extracted_data` dataframe from its initialized value to the correct
descriptive label. We then remove the y\_numlabels column, as it is
redundant and no longer needed.

### 4. Appropriately labeling the data set with descriptive variable names

As described in step 1. Merging …, the features.txt file provides
variable names which are sufficiently descriptive.
`names(X_test)<-t(features[,2])` assigns the column names of the x\_test
and x\_train dataframes to those features, which were loaded into the
variable `features`. The activity column of extracted\_data was
described in 3.

### 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject.

A tidy data set, by definition, has one variable per column and one
observation in each row. With 30 test subjects performing 6 activities
each, there should be 180 rows or “observations” for the mean of each of
79 variables of extracted\_data. The `extracted_data` dataframe is
melted into a long dataframe dmelt of 813,621 rows (79 variables x
10,299 values each) and 4 columns. The `dcast()` function is then used
to calculate the mean for each activity/subject pair.

| Activity | Subject | Variable | Value |
|----------|:-------:|:--------:|:-----:|
|          |         |          |       |

The extracted tidy data set is stored in the dataframe
`mean_by_activity` (180 rows x 81 columns). There is no need for an
index column in the final dataset, so it is removed. The final tidy data
set is saved to “tidy\_data.txt” with the `write.table()` function.

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 26%" />
<col style="width: 26%" />
<col style="width: 26%" />
</colgroup>
<thead>
<tr class="header">
<th>Activity</th>
<th style="text-align: center;">Subject</th>
<th style="text-align: center;">46 mean variables</th>
<th style="text-align: center;">33 standard deviation variables</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>1 of 6 descriptive labels</td>
<td style="text-align: center;">1-30</td>
<td style="text-align: center;">46 calculated averages for given activity/label</td>
<td style="text-align: center;">33 calculated averages for given activity/label</td>
</tr>
</tbody>
</table>

APPENDIX
--------

### 79 Feature Variables Extracted from 561 Feature Variables

As stated previously, the consolidated data from X\_test and X\_train
files contains 561 variables generated from the three-axis accelerometer
and gyroscope data readings of the experiments (Human Activity
Recognition Using Smartphones Dataset, Version 1.0). Only 79 of these
variables were extracted, including 46 mean variables and 33 standard
deviation variables, that end up in the **tidy\_data.txt** file. As
shown under heading 5, the first two columns of the `mean_by_activity`
dataframe and tidy\_data.txt are Activity and Subject variables, so
there are a total of 81 columns.

**Mean variables (46)**

Appearing in following order as Columns 3-48 in `mean_by_activity`
dataframe or in tidy\_data.txt.

| 1-16                   |           17-32           |              33-46             |
|------------------------|:-------------------------:|:------------------------------:|
| tBodyAcc\_mean\_X      |    tGravityAccMag\_mean   |       fBodyGyro\_mean\_X       |
| tBodyAcc\_mean\_Y      |   tBodyAccJerkMag\_mean   |       fBodyGyro\_mean\_Y       |
| tBodyAcc\_mean\_Z      |     tBodyGyroMag\_mean    |       fBodyGyro\_mean\_Z       |
| tGravityAcc\_mean\_X   |   tBodyGyroJerkMag\_mean  |     fBodyGyro\_meanFreq\_X     |
| tGravityAcc\_mean\_Y   |     fBodyAcc\_mean\_X     |     fBodyGyro\_meanFreq\_Y     |
| tGravityAcc\_mean\_Z   |     fBodyAcc\_mean\_Y     |     fBodyGyro\_meanFreq\_Z     |
| tBodyAccJerk\_mean\_X  |     fBodyAcc\_mean\_Z     |        fBodyAccMag\_mean       |
| tBodyAccJerk\_mean\_Y  |   fBodyAcc\_meanFreq\_X   |      fBodyAccMag\_meanFreq     |
| tBodyAccJerk\_mean\_Z  |   fBodyAcc\_meanFreq\_Y   |    fBodyBodyAccJerkMag\_mean   |
| tBodyGyro\_mean\_X     |   fBodyAcc\_meanFreq\_Z   |  fBodyBodyAccJerkMag\_meanFreq |
| tBodyGyro\_mean\_Y     |   fBodyAccJerk\_mean\_X   |     fBodyBodyGyroMag\_mean     |
| tBodyGyro\_mean\_Z     |   fBodyAccJerk\_mean\_Y   |   fBodyBodyGyroMag\_meanFreq   |
| tBodyGyroJerk\_mean\_X |   fBodyAccJerk\_mean\_Z   |   fBodyBodyGyroJerkMag\_mean   |
| tBodyGyroJerk\_mean\_Y | fBodyAccJerk\_meanFreq\_X | fBodyBodyGyroJerkMag\_meanFreq |
| tBodyGyroJerk\_mean\_Z | fBodyAccJerk\_meanFreq\_Y |                                |
| tBodyAccMag\_mean      | fBodyAccJerk\_meanFreq\_Z |                                |

**Standard deviation variables (33)**

Appearing in order as Columns 49-81 in mean\_by\_activity dataframe or
in tidy\_data.txt.

| 1-11                 |         12-22         |           23-33           |
|----------------------|:---------------------:|:-------------------------:|
| tBodyAcc\_std\_X     |   tBodyGyro\_std\_Z   |      fBodyAcc\_std\_Z     |
| tBodyAcc\_std\_Y     | tBodyGyroJerk\_std\_X |    fBodyAccJerk\_std\_X   |
| tBodyAcc\_std\_Z     | tBodyGyroJerk\_std\_Y |    fBodyAccJerk\_std\_Y   |
| tGravityAcc\_std\_X  | tBodyGyroJerk\_std\_Z |    fBodyAccJerk\_std\_Z   |
| tGravityAcc\_std\_Y  |    tBodyAccMag\_std   |     fBodyGyro\_std\_X     |
| tGravityAcc\_std\_Z  |  tGravityAccMag\_std  |     fBodyGyro\_std\_Y     |
| tBodyAccJerk\_std\_X |  tBodyAccJerkMag\_std |     fBodyGyro\_std\_Z     |
| tBodyAccJerk\_std\_Y |   tBodyGyroMag\_std   |      fBodyAccMag\_std     |
| tBodyAccJerk\_std\_Z | tBodyGyroJerkMag\_std |  fBodyBodyAccJerkMag\_std |
| tBodyGyro\_std\_X    |    fBodyAcc\_std\_X   |   fBodyBodyGyroMag\_std   |
| tBodyGyro\_std\_Y    |    fBodyAcc\_std\_Y   | fBodyBodyGyroJerkMag\_std |
