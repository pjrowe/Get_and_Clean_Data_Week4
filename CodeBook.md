CodeBook for Getting and Cleaning Data Course Project
-----------------------------------------------------

This CodeBook describes the variables, the data, and any transformations
or work that was performed to clean up the data for the Course Project.

The source data inlcudes a number of raw data files and descriptive
information that is not actually needed or used to perform the cleaning
and preparation of the final tidy data set. Thus, we will discuss only
the files and data used in this process.

In the first section, we discuss the 9 Data Source files actually used.
Then, we described the variables in the final tidy data set, from
tidy\_data.txt.

### Data Source

The dataset downloaded for cleaning was the Human Activity Recognition
Using Smartphones Dataset, Version 1.0, via the link to in the Coursera
materials
\[**here**\].(<a href="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" class="uri">https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip</a>).
The download process was automated in the R script.

The files used include the following 9 files:

-   **activity\_label.txt** - a simple file showing the mapping of
    numbered activity labels to its descriptive label. Each
    subject/person performed six activities during the experiment
    (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING,
    LAYING). This was eventually used to transform the numbered labels
    in the y\_train.txt and y\_test.txt files to the descriptive label,
    which is required for the final tidy data set. For specifics of this
    transformation, see step 3 of the README.md file.
-   **features.txt** - a numbered list of 561 feature variables for the
    X\_test and X\_train files, generated from the three-axis
    accelerometer and gyroscope data readings of the experiments (Human
    Activity Recognition Using Smartphones Dataset, Version 1.0). The
    X\_train.txt and X\_test.txt data is unlabeled, so the features.txt
    file is used to match the columns of the X data with variable
    names.  
-   **features\_info.txt** - This file describes the background of how
    the 561 variables were derived from raw experimental data, but since
    we did not do any processing of the data, we did not use this file
    other than to understand how to filter for mean and standard
    deviation variables.

The remaining 6 files are described below in an excerpt from the
README.md file.

#### Excerpt from README: 1. Merging the training and the test sets to create one data set

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

-   **y\_test.txt :** 2,947 observations(rows) and 1 column with a
    number label (1-6) for the activity performed by the experimental
    subjects. There are 9 subjects (2, 4, 9, 10, 12, 13, 18, 20, and 24)
    included vs. a total of 30, so 30% of the data were for the test
    data set and the remaining 21 subjects (70%) were part of the
    training set.  
-   **subject\_test.txt :** 2,947 rows x 1 column with numbered label
    (1-30) of subject who performed the activity.
-   **X\_test.txt :** 2,947 observations(rows) x 561 columns of feature
    variables. For each subject, two experiments were run, each of about
    163 rows (i.e., 163 rows x 9 subjects x 2 experiments = 2,934 total
    rows). Due to sampling and how the experiments were manually
    labeled, the samples or rows are not exactly the same from
    experiment to experiment. Features are normalized and bounded within
    \[-1,1\].

-   **y\_train.txt :** 7,352 rows x 1 column.
-   **subject\_train.txt :** 7,352 rows x 1 column, with numbered label
    (1-30) of subject who performed the activity.
-   **X\_train.txt :** 7,352 rows x 561 columns. There were 21 subjects
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

### Tidy\_data.txt variables

The tidy\_data.txt file is 180 rows by 81 columns, showing the
calculated mean value for 79 variables for each activity x subject pair
(6 activities x 30 subjects = 180 rows). A full description of how the
source data was processed to get the final data can be found in
README.md.

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

#### 79 Feature Variables Extracted from 561 Feature Variables

As stated previously, the consolidated data from X\_test and X\_train
files contains 561 variables generated from the three-axis accelerometer
and gyroscope data readings of the experiments (Human Activity
Recognition Using Smartphones Dataset, Version 1.0). Only 79 of these
variables were extracted, including 46 mean variables and 33 standard
deviation variables, that end up in the **tidy\_data.txt** file. As
shown under heading 5 of the README.md file, the first two columns of
the `mean_by_activity` dataframe and tidy\_data.txt are Activity and
Subject variables, so there are a total of 81 columns.

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
