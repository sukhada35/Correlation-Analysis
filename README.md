# Data Cleaning and Correlation Analysis Project

This repository contains a project focused on cleaning a dataset and analyzing correlations between different numeric variables. The project uses R programming and various libraries to handle data cleaning, outlier detection, and visualization of the correlations through a heatmap.

## Overview

This project involves:
- Cleaning the dataset by removing outliers using the Interquartile Range (IQR) method.
- Generating boxplots for numeric columns.
- Creating a correlation heatmap to visualize relationships between numeric variables.


### Main Steps:

1. **Data Loading**: The dataset is loaded into the project using `read_csv()`, and a copy is saved for future use.
   
2. **Column Analysis**: All column names are printed, and numeric columns are identified for further analysis.

3. **Outlier Detection**:
   - The IQR method is applied to detect and remove outliers.
   - Boxplots are generated to visualize the distribution of each numeric column and check for any anomalies.

4. **Data Cleaning**:
   - Rows containing outliers are filtered out, ensuring the data is clean and ready for analysis.

5. **Correlation Analysis**:
   - A scatter plot is created to visualize the relationship between two chosen columns (e.g., Hours Studied vs. Exam Score).
   - A heatmap is generated to display the correlation matrix of the numeric variables.

### Installation

To run this project locally, ensure you have R installed, along with the following required packages:

```R
install.packages("ggplot2")
install.packages("dplyr")
install.packages("readr")
install.packages("reshape2")

