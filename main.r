install.packages("ggplot2")
install.packages("dplyr")
install.packages("readr")
install.packages("reshape2")

# Load necessary libraries
library(ggplot2)
library(dplyr)
library(readr)

# Load the dataset
data <- read_csv('data.csv')

write_csv(data, 'data.csv') # Saves a copy

# Print column names to analyze
print(colnames(data))

# Check which columns are numeric
numeric_columns <- sapply(data, is.numeric)
numeric_data <- data[, numeric_columns] # Create a dataframe with only numeric columns

# Check for any issues with the numeric columns before summarizing
if (ncol(numeric_data) > 0) {
  print(summary(numeric_data)) # Summary statistics for numeric columns
} else {
  cat("No numeric columns found in the dataset.\n")
}

# Set layout for multiple boxplots
par(mfrow=c(2, 2))  

# Loop through each numeric column and create boxplots, handling errors
for (col in colnames(numeric_data)) {
  tryCatch({
    if (is.numeric(numeric_data[[col]])) {
      boxplot(numeric_data[[col]], main = paste("Boxplot of", col), horizontal = TRUE)
    }
  }, error = function(e) {
    cat("Error plotting boxplot for column:", col, "\n", "Error message:", e, "\n")
  })
}

# Step 3: Calculate IQR and check bounds
Q1 <- apply(numeric_data, 2, quantile, 0.25, na.rm = TRUE)
Q3 <- apply(numeric_data, 2, quantile, 0.75, na.rm = TRUE)
IQR <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

print("IQR values")
# Print bounds for inspection
print(data.frame(Q1, Q3, IQR, lower_bound, upper_bound))

# Step 4: Filter out outliers
data_cleaned <- data

for (i in which(numeric_columns)) {
  initial_rows <- nrow(data_cleaned)
  column_name <- colnames(data_cleaned)[i]
 
  # Check if the bounds are reasonable
  if (is.na(lower_bound[i]) || is.na(upper_bound[i])) {
    cat("Skipping filtering for", column_name, "due to NA bounds.\n")
    next
  }
 
  data_cleaned <- data_cleaned %>%
    filter((.data[[column_name]] >= lower_bound[i] & .data[[column_name]] <= upper_bound[i]) | is.na(.data[[column_name]]))
 
  filtered_rows <- nrow(data_cleaned)
  cat("Filtered column:", column_name, "- Rows before:", initial_rows, "- Rows after:", filtered_rows, "\n")
 
  # Handle case where filtering removes all data
  if (filtered_rows == 0) {
    cat("Warning: All data removed for column:", column_name, "\n")
    # Optionally retain the column with NA
    data_cleaned[[column_name]] <- NA
  }
}

# Step 5: Save the cleaned data (overwrite data_cleaned.csv)
write_csv(data_cleaned, 'data_cleaned.csv')

# Step 6: Check cleaned data dimensions
print(dim(data_cleaned))

# Step 7: Scatter Plot (replace "Attendance" and "Previous_Scores" with random columns)
if ("Hours_Studied" %in% colnames(data_cleaned) & "Exam_Score" %in% colnames(data_cleaned)) {
  ggplot(data_cleaned, aes(x = Hours_Studied, y = Exam_Score)) +
    geom_point() +
    labs(title = "Scatter plot of Hours Studied vs Exam Score",
         x = "Hours Studied", y = "Exam Score") +
    theme_minimal()
} else {
  cat("Columns 'Hours_Studied' and/or 'Exam_Score' do not exist in the dataset.\n")
}

# Step 8: Correlation Heatmap
# Calculate correlation matrix (use 'complete.obs' to handle NA values)
cor_matrix <- cor(data_cleaned[, numeric_columns], use = "complete.obs")

# Melt the correlation matrix for heatmap visualization
melted_cor <- melt(cor_matrix)

# Create the heatmap
# Create the heatmap
ggplot(data = melted_cor, aes(x = Var1, y = Var2, fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                       midpoint = 0, limit = c(-1, 1), space = "Lab",
                       name = "Correlation") +
  theme_minimal() +
  labs(title = "Correlation Heatmap", x = "", y = "") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))