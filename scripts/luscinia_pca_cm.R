# Load necessary libraries for plotting and data manipulation
library(ggplot2)
library(ggfortify)
library(ggsci)
library(caret)   # For confusion matrix calculations
library(plyr)    # For revaluing factors
library(viridis) # For color scales

# Set working directory to where the data files are located
setwd("Z:/MaiaProjects/ML_project/Analysis_Scripts")

# Read data from CSV file
res <- read.csv('pc_update.csv')

# Convert data to a data frame and rename columns for PCA analysis
pc <- data.frame(res)
names(pc)[4] <- 'PC1'    # Rename the 4th column to 'PC1'
names(pc)[5] <- 'PC2'    # Rename the 5th column to 'PC2'
names(pc)[1] <- 'Species' # Rename the 1st column to 'Species'

# Define custom colors for species in the plots
colors <- c("#d55e00","#0072b2","#cc79a7","#330066")

# Plot PCA results with species color-coded
ggplot(pc, aes(x=PC1, y=PC2, color=Species)) + 
  geom_point() + # Add points for each species
  scale_color_manual(values=colors) + # Apply custom colors
  theme_minimal(base_size = 16) + # Use a minimal theme with larger text
  theme(
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text = element_text(size = 16),
    legend.text = element_text(size=16),
    legend.title = element_text(size=18)
  ) +
  xlab("PC1: 87.3% of Variation") + # Customize axis labels with explained variance
  ylab("PC2: 91.5% of variation") 

# Recode 'k4' values to factors and reorder factor levels
pc$k4 <- pc$X..km_cats_4_value
pc$k4 <- as.factor(pc$k4)
pc$k4 <- factor(pc$k4, levels=c("4","2","3","1"))

                
# Plot PCA results with 'k4' groupings
ggplot(pc, aes(x=PC1, y=PC2, color=k4))  +
  geom_point() +
  theme_minimal(base_size = 16) +
  theme(
    axis.title.x = element_text(size = 18),
    axis.title.y = element_text(size = 18),
    axis.text = element_text(size = 16),
    legend.text = element_text(size=16),
    legend.title = element_text(size=18)
  ) +
  xlab("PC1: 87.3% of Variation") +
  ylab("PC2: 91.5% of variation") 

expected <- pc$Species
predicted <- pc$k4
# Revalue 'k4' factor levels to match species names
predicted <- revalue(predicted, c("1"="Pantropical spotted dolphin", 
                                  "2"="Guiana dolphin", 
                                  "3"="False killer whale",
                                  "4"="Bottlenose dolphin"))
# Convert species and predictions to factors for comparison
expected <- factor(expected)
predicted <- factor(predicted)

# Calculate and print confusion matrix
cm <- confusionMatrix(predicted,expected)
cm

