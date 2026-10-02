# ============================================================
# WEEK 4: COMPREHENSIVE DATA ANALYSIS REPORTING
# ============================================================
# Objective:
# Integrate data cleaning, visualization, statistical analysis,
# and predictive modeling into one comprehensive analysis.
# ============================================================


# ------------------------------------------------------------
# 1. INSTALL AND LOAD REQUIRED PACKAGES
# ------------------------------------------------------------

required_packages <- c(
  "tidyverse",
  "ggplot2",
  "dplyr",
  "readr",
  "caret",
  "scales"
)

new_packages <- required_packages[
  !(required_packages %in% installed.packages()[, "Package"])
]

if (length(new_packages) > 0) {
  install.packages(new_packages)
}

library(tidyverse)
library(ggplot2)
library(dplyr)
library(readr)
library(caret)
library(scales)


# ------------------------------------------------------------
# 2. IMPORT DATASET
# ------------------------------------------------------------

# Change this filename according to your dataset
data <- read_csv("C:/Users/HP/Desktop/yuvaIntern/task4/data/your_dataset.csv")

# Display first records
head(data)

# Display dataset dimensions
dim(data)

# Display column names
colnames(data)

# Display structure
str(data)

# Summary statistics
summary(data)


# ------------------------------------------------------------
# 3. DATA QUALITY CHECK
# ------------------------------------------------------------

# Check missing values
missing_values <- colSums(is.na(data))

print("Missing values in each column:")
print(missing_values)

# Percentage of missing values
missing_percentage <- colSums(is.na(data)) / nrow(data) * 100

print("Missing value percentage:")
print(round(missing_percentage, 2))


# Check duplicate rows
duplicate_rows <- sum(duplicated(data))

cat("Number of duplicate rows:", duplicate_rows, "\n")


# ------------------------------------------------------------
# 4. DATA CLEANING
# ------------------------------------------------------------

# Remove duplicate records
data_clean <- data %>%
  distinct()

cat("Rows before cleaning:", nrow(data), "\n")
cat("Rows after removing duplicates:", nrow(data_clean), "\n")


# Remove rows containing missing values
data_clean <- na.omit(data_clean)

cat("Rows after removing missing values:",
    nrow(data_clean), "\n")


# ------------------------------------------------------------
# 5. CLEAN COLUMN NAMES
# ------------------------------------------------------------

# Convert column names into consistent format
names(data_clean) <- make.names(names(data_clean))

print("Cleaned column names:")
print(names(data_clean))


# ------------------------------------------------------------
# 6. DATA TYPES
# ------------------------------------------------------------

str(data_clean)

# Summary after cleaning
summary(data_clean)


# ------------------------------------------------------------
# 7. DESCRIPTIVE STATISTICS
# ------------------------------------------------------------

# Numerical summary
numeric_data <- data_clean %>%
  select(where(is.numeric))

summary(numeric_data)


# Mean of numerical variables
means <- sapply(numeric_data, mean, na.rm = TRUE)

print("Mean values:")
print(means)


# Median
medians <- sapply(numeric_data, median, na.rm = TRUE)

print("Median values:")
print(medians)


# Standard deviation
standard_deviation <- sapply(
  numeric_data,
  sd,
  na.rm = TRUE
)

print("Standard deviation:")
print(standard_deviation)


# ------------------------------------------------------------
# 8. DATA VISUALIZATION
# ------------------------------------------------------------

# Histogram for first numerical variable

if (ncol(numeric_data) >= 1) {

  first_variable <- names(numeric_data)[1]

  p1 <- ggplot(
    data_clean,
    aes(x = .data[[first_variable]])
  ) +
    geom_histogram(
      bins = 30,
      color = "black"
    ) +
    labs(
      title = paste("Distribution of", first_variable),
      x = first_variable,
      y = "Frequency"
    ) +
    theme_minimal()

  print(p1)

  ggsave(
    "C:/Users/HP/Desktop/yuvaIntern/task4/output/01_distribution.png",
    p1,
    width = 8,
    height = 5
  )
}


# ------------------------------------------------------------
# 9. BOX PLOT
# ------------------------------------------------------------

if (ncol(numeric_data) >= 1) {

  p2 <- ggplot(
    data_clean,
    aes(y = .data[[first_variable]])
  ) +
    geom_boxplot() +
    labs(
      title = paste("Box Plot of", first_variable),
      y = first_variable
    ) +
    theme_minimal()

  print(p2)

  ggsave(
    "C:/Users/HP/Desktop/yuvaIntern/task4/output/02_boxplot.png",
    p2,
    width = 8,
    height = 5
  )
}


# ------------------------------------------------------------
# 10. CORRELATION ANALYSIS
# ------------------------------------------------------------

if (ncol(numeric_data) >= 2) {

  correlation_matrix <- cor(
    numeric_data,
    use = "complete.obs"
  )

  print("Correlation Matrix:")
  print(round(correlation_matrix, 2))


  # Convert correlation matrix into data frame
  correlation_df <- as.data.frame(
    as.table(correlation_matrix)
  )

  names(correlation_df) <- c(
    "Variable1",
    "Variable2",
    "Correlation"
  )


  # Correlation heatmap
  p3 <- ggplot(
    correlation_df,
    aes(
      x = Variable1,
      y = Variable2,
      fill = Correlation
    )
  ) +
    geom_tile() +
    geom_text(
      aes(
        label = round(Correlation, 2)
      ),
      size = 3
    ) +
    scale_fill_gradient2(
      low = "blue",
      mid = "white",
      high = "red",
      midpoint = 0
    ) +
    labs(
      title = "Correlation Heatmap",
      x = "",
      y = ""
    ) +
    theme_minimal() +
    theme(
      axis.text.x = element_text(
        angle = 45,
        hjust = 1
      )
    )

  print(p3)

  ggsave(
    "C:/Users/HP/Desktop/yuvaIntern/task4/output/03_correlation_heatmap.png",
    p3,
    width = 9,
    height = 7
  )
}


# ------------------------------------------------------------
# 11. SCATTER PLOT
# ------------------------------------------------------------

if (ncol(numeric_data) >= 2) {

  x_variable <- names(numeric_data)[1]
  y_variable <- names(numeric_data)[2]

  p4 <- ggplot(
    data_clean,
    aes(
      x = .data[[x_variable]],
      y = .data[[y_variable]]
    )
  ) +
    geom_point(alpha = 0.6) +
    geom_smooth(
      method = "lm",
      se = TRUE
    ) +
    labs(
      title = paste(
        y_variable,
        "vs",
        x_variable
      ),
      x = x_variable,
      y = y_variable
    ) +
    theme_minimal()

  print(p4)

  ggsave(
    "C:/Users/HP/Desktop/yuvaIntern/task4/output/04_scatter_plot.png",
    p4,
    width = 8,
    height = 5
  )
}


# ------------------------------------------------------------
# 12. STATISTICAL ANALYSIS
# ------------------------------------------------------------

if (ncol(numeric_data) >= 2) {

  x <- numeric_data[[1]]
  y <- numeric_data[[2]]

  # Pearson correlation test
  correlation_test <- cor.test(
    x,
    y,
    method = "pearson"
  )

  print("Pearson Correlation Test:")
  print(correlation_test)
}


# ------------------------------------------------------------
# 13. LINEAR REGRESSION MODEL
# ------------------------------------------------------------

if (ncol(numeric_data) >= 2) {

  x_variable <- names(numeric_data)[1]
  y_variable <- names(numeric_data)[2]

  formula_model <- as.formula(
    paste(
      y_variable,
      "~",
      x_variable
    )
  )

  linear_model <- lm(
    formula_model,
    data = data_clean
  )

  print("Linear Regression Model:")
  print(summary(linear_model))


  # Model predictions
  data_clean$Predicted <- predict(
    linear_model,
    newdata = data_clean
  )


  # Regression plot
  p5 <- ggplot(
    data_clean,
    aes(
      x = .data[[x_variable]],
      y = .data[[y_variable]]
    )
  ) +
    geom_point() +
    geom_smooth(
      method = "lm",
      se = TRUE
    ) +
    labs(
      title = "Linear Regression Analysis",
      x = x_variable,
      y = y_variable
    ) +
    theme_minimal()

  print(p5)

  ggsave(
    "C:/Users/HP/Desktop/yuvaIntern/task4/output/05_regression_plot.png",
    p5,
    width = 8,
    height = 5
  )
}


# ------------------------------------------------------------
# 14. MODEL PERFORMANCE
# ------------------------------------------------------------

if (exists("linear_model")) {

  actual <- data_clean[[y_variable]]
  predicted <- data_clean$Predicted

  # Mean Absolute Error
  MAE <- mean(
    abs(actual - predicted)
  )

  # Mean Squared Error
  MSE <- mean(
    (actual - predicted)^2
  )

  # Root Mean Squared Error
  RMSE <- sqrt(MSE)

  # R-squared
  R_squared <- summary(
    linear_model
  )$r.squared


  cat("\nMODEL PERFORMANCE\n")
  cat("-----------------------------\n")
  cat("MAE:", round(MAE, 4), "\n")
  cat("MSE:", round(MSE, 4), "\n")
  cat("RMSE:", round(RMSE, 4), "\n")
  cat(
    "R-squared:",
    round(R_squared, 4),
    "\n"
  )
}


# ------------------------------------------------------------
# 15. RESIDUAL ANALYSIS
# ------------------------------------------------------------

if (exists("linear_model")) {

  residual_data <- data.frame(
    Fitted = fitted(linear_model),
    Residuals = residuals(linear_model)
  )

  p6 <- ggplot(
    residual_data,
    aes(
      x = Fitted,
      y = Residuals
    )
  ) +
    geom_point() +
    geom_hline(
      yintercept = 0,
      linetype = "dashed"
    ) +
    labs(
      title = "Residual Analysis",
      x = "Fitted Values",
      y = "Residuals"
    ) +
    theme_minimal()

  print(p6)

  ggsave(
    "C:/Users/HP/Desktop/yuvaIntern/task4/output/06_residual_plot.png",
    p6,
    width = 8,
    height = 5
  )
}


# ------------------------------------------------------------
# 16. EXPORT CLEAN DATA
# ------------------------------------------------------------

write_csv(
  data_clean,
  "C:/Users/HP/Desktop/yuvaIntern/task4/cleaned_dataset_week4.csv"
)


# ------------------------------------------------------------
# 17. EXPORT CORRELATION MATRIX
# ------------------------------------------------------------

if (exists("correlation_matrix")) {

  write.csv(
    correlation_matrix,
    "C:/Users/HP/Desktop/yuvaIntern/task4/correlation_matrix.csv"
  )
}


# ------------------------------------------------------------
# 18. SAVE MODEL
# ------------------------------------------------------------

if (exists("linear_model")) {

  saveRDS(
    linear_model,
    "C:/Users/HP/Desktop/yuvaIntern/task4/linear_regression_model.rds"
  )
}


# ------------------------------------------------------------
# 19. FINAL ANALYSIS SUMMARY
# ------------------------------------------------------------

cat("\n============================================\n")
cat("WEEK 4 ANALYSIS COMPLETED SUCCESSFULLY\n")
cat("============================================\n")

cat(
  "Original rows:",
  nrow(data),
  "\n"
)

cat(
  "Cleaned rows:",
  nrow(data_clean),
  "\n"
)

cat(
  "Number of variables:",
  ncol(data_clean),
  "\n"
)

if (exists("R_squared")) {

  cat(
    "Model R-squared:",
    round(R_squared, 4),
    "\n"
  )
}

cat("\nGenerated files:\n")
cat("1. cleaned_dataset_week4.csv\n")
cat("2. correlation_matrix.csv\n")
cat("3. 01_distribution.png\n")
cat("4. 02_boxplot.png\n")
cat("5. 03_correlation_heatmap.png\n")
cat("6. 04_scatter_plot.png\n")
cat("7. 05_regression_plot.png\n")
cat("8. 06_residual_plot.png\n")
cat("9. linear_regression_model.rds\n")

cat("\nWeek 4 comprehensive analysis completed.\n")