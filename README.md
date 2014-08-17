# "Getting and Cleaning Data" Coursera Course Project

## Overview

See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones for an overview of the dataset and the CODEBOOK.md file included in this repository.

This project seeks to combine the data within the "Human Activity Recognition Using Smartphones" dataset into a tidy dataset.

## Installation and Setup

* Download the source files and dataset from the github repository https://github.com/dfredriksen/cleaningdataproject.git

* The "plyr" package is required. Type install.packages("plyr") from the R command prompt before sourcing the run_analysis.R script to install this dependency.

* The "Human Activity Recognition Using Smartphones" dataset must be downloaded and installed in your working directory along with the run_analysis.R script. This is included in the repository, but can also be obtained at  http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

* make sure your working directory is set to the same directory as the source code. You can use the setwd(<path>) command, where <path> is the path to your working directory.

* type source('<path>run_analysis.R') where <path> is the path to your working directory.

## Description

The run_analysis.R script loads two data sets as variables in your environment. The first data set is called messy_dataset, and the second is called tidy_dataset. It also saves a copy of tidy_dataset to the working directory as tidy_dataset.txt using write.table(). The steps the script takes are as follows:

Note: Camel Case was chosen for the table header names to improve readability

* Initializes the "plyr" library

* Initializes the messy_dataset and tidy_dataset global variables

* defines the function analyze_samsung_data()

* The function analyze_samsung_data() is called. It begins by opening the features.txt file and stores the data into the features variable using read.table(), and sets the column names of the features table to be FeatureId and FeatureLabel

* loads the activity_labels.txt file into the activity_labels variable and sets the column names to ActivityId and ActivityLabel

* Loads the training data into variables train_subject, train_x, and train_y

* Loads the test data into variables test_subject, test_x, test_y

* Combines the training and test x data using rbind into a variable called raw_x

* the column names of raw_x are set to the values contained in the FeatureLabel column of the features variable

* A subset of raw_x is selected based on column names containing -mean or -std in the description using grep. This allows us to only grab values representing the mean or standard deviation. This is saved into the filtered_x variable.

* Column names are then tidied for the filtered_x dataset so that measurement domain and type of measurement is clearly spelled out, special characters are removed, and everything is formatted to CamelCase to aid in readability and ease of access. This is stored in the variable_column_names variable

* The test and training y data is then combined into raw_y using rbind, and the single column is given the name ActivityId so that it can be joined to the activity_labels dataset.

* The training and test subject data is combined into raw_subject and given the column name "Subject"

* the x,y, and subject columns are bound together into the bound_data variable 

* the messy_dataset is then created by merging the activity labels into the bound_data on ActivityId

* The tidy_dataset is then created by using ddply to calculate the means on all variable_column_names columns, grouped by Subject and ActivityLabel. The final tidy column headers are set to Subject, Activity, and the values in variable_column_names

* The tidy_dataset variable is saved to tidy_dataset.txt in the current working directory using write.table, with row.names set to false.




