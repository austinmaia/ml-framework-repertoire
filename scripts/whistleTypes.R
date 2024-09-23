# Analysis of whistle types from ARTwarp categorization

#------------------------------------------------------------------------------

# Load necessary libraries
library(ggplot2)  # For plotting
library(dplyr)    # For data manipulation

# Set working directory to the path containing the data file
setwd("Z:/MaiaProjects/ML_project/allcontours")

# Read whistle types data from a CSV file
whistles <- read.csv("whistle_types.csv")

# Arrange the data by the 'category' column for better readability
arrange(whistles, category)

# Group whistle types by category and identify if a category is shared between different groups
whistletypes <- whistles %>%
  group_by(category) %>%
  mutate(GroupName = ifelse(n_distinct(groups) > 1, "Shared", as.character(groups))) %>% # Assign "Shared" to categories that appear in multiple groups
  distinct(category, Type, GroupName)  # Remove duplicate rows

# Identify shared whistle types that appear across multiple categories
shared_items <- whistles %>%
  group_by(category) %>%
  filter(n_distinct(groups) > 1) %>%  # Filter items that are shared across categories
  mutate(GroupName = "Shared") %>%    # Mark these items with "Shared" as GroupName
  distinct(category, Type, GroupName) # Remove duplicate rows

# Merge shared items into the main whistle types data
whistletypes <- whistles %>%
  mutate(GroupName = as.character(groups)) %>%  # Keep the original group names
  bind_rows(
    shared_items %>% 
      select(-category) %>% 
      mutate(GroupName = "Shared") # Add a row for shared items with "Shared" GroupName
  ) %>%
  distinct(category, Type, GroupName) # Ensure there are no duplicates

# Calculate the occurrence and frequency of each whistle type by group
whistletypeoccurence <- whistletypes %>%
  group_by(Type, GroupName) %>%
  summarize(count = n()) %>%              # Count occurrences of each type
  group_by(GroupName) %>%
  mutate(freq = count / sum(count) * 100) # Calculate frequency as a percentage of total

# Create all possible combinations of whistle types and group names
all_combinations <- expand.grid(
  Type = unique(whistletypes$Type),
  GroupName = unique(whistletypes$GroupName)
)

# Join calculated occurrences with all combinations to ensure all pairs are represented
whistletypeoccurence <- whistletypes %>%
  group_by(Type, GroupName) %>%
  summarize(count = n()) %>%
  right_join(all_combinations, by = c("Type", "GroupName")) %>% # Ensure all combinations are included
  group_by(GroupName) %>%
  mutate(count = ifelse(is.na(count), 0, count),                # Replace NA counts with 0
         freq = count / sum(count) * 100)                      # Recalculate frequency

# Create a bar plot of whistle type frequencies by group
plotRep <- ggplot(whistletypeoccurence, aes(x = GroupName, 
                                            y = freq,
                                            fill = Type)) +
  geom_bar(stat = "identity", 
           position = "dodge") +                              # Create a dodged bar plot
  geom_text(aes(label = paste(format(round(freq, digits = 0)), "%")), 
            size = 4, 
            vjust = -0.75, position = position_dodge(0.9))    # Add frequency labels on bars

# Finalize the plot with labels and customizations
final <- plotRep + labs(x = "Species", y = "Abundance (% of repertoire)") + 
  scale_x_discrete(labels = c("Bottlenose dolphin\n 55 whistle types", 
                              "False killer whale\n 31 whistle types", 
                              "Guiana dolphin\n 43 whistle types", 
                              "Pantropical spotted dolphin\n 34 whistle types",
                              "Shared\n 19 whistle types"))

# Add a minimal theme, increase font sizes, and add a dashed line annotation
final + theme_minimal(base_size = 16) +  # Set a minimal theme with increased text sizes
  theme(
    axis.title.x = element_text(size = 18),  # Increase x-axis title size
    axis.title.y = element_text(size = 18),  # Increase y-axis title size
    axis.text = element_text(size = 16),     # Increase axis text size
    legend.text = element_text(size = 14),   # Increase legend text size
    legend.title = element_text(size = 16)   # Increase legend title size
  ) +
  annotate("segment", x = 4.5, xend = 4.5, y = 0, yend = max(whistletypeoccurence$freq), 
           color = "black", linetype = "dashed", size = 1) # Add a dashed line separator
