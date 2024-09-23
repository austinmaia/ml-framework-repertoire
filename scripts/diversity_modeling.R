# Diversity modelling
# The script is designed to perform biodiversity modeling and 
# analysis on whistle data from different dolphin species. It uses 
# various statistical and graphical methods to estimate species richness, 
# diversity indices, coupon collector simulations, and capture-recapture estimates. 
# The data comes from a CSV file containing ARTwarp output, which is loaded 
# and processed to analyze the distribution and characteristics of whistles 
# per species.

# Load necessary libraries
library(data.table)
library(iNEXT)
library(ggplot2)
library(Rcapture)
library(dplyr)
library(tidyverse)

# Load the CSV file of ARTwarp output into a data table
setwd("Z:/MaiaProjects/ML_project/allcontours")
dt <- data.table(read.csv('95_3.csv')) 

# Count the number of whistles per species
dt[,.N,by=species] # 118 sotalia, 120 stenella, 116 fkw, 120 bottlenose

# Count the total number of unique categories
dt[,length(unique(category)),] # 134 categories in total 

# Count the number of unique categories for each species
dt[,length(unique(category)),by=species] # 41 sotalia, 40 stenella, 31 fkw, 45 bottlenose

# Add a column with the number of each whistle type per species-category combination
dt[,numWhistlesspecies:=.N,by=c('species','category')] 

# Create an empty data frame to store results with 5 columns for each diversity metric
results <- data.frame(matrix(ncol=5, nrow=4))
colnames(results) <- c('Richness','Shannon','Simpson','CouponCollector','CaptureRecapture')
rownames(results) <- c('Bottlenose', 'FalseKillerWhale','Guiana','Pantropical')


# iNEXT ---------------------------------------------------

# Sub-sample one row per category & species to avoid redundancy
cats <- dt[dt[ , .I[sample(.N,1)] , by = c('species','category')]$V1] 

# Extract and sort the number of whistles for each category by species
guiana <- sort(cats[species=="Guiana",c(numWhistlesspecies),], decreasing = TRUE) 
pantropical <- sort(cats[species=="Pantropical",c(numWhistlesspecies),], decreasing = TRUE) 
falsekillerwhale <- sort(cats[species=="FalseKillerWhale",c(numWhistlesspecies),], decreasing = TRUE) 
bottlenose <- sort(cats[species=="Bottlenose",c(numWhistlesspecies),], decreasing = TRUE) 

# Combine all species data into a list for iNEXT analysis
combined <- list('Guiana' = guiana, 'Pantropical' = pantropical, 
                 'FalseKillerWhale' = falsekillerwhale, 'Bottlenose' = bottlenose)

# Run iNEXT for different levels of diversity (Q 0, 1, 2)
# Q = 0: Species Richness
q0 <- iNEXT(combined, q=0, datatype="abundance")
print(q0)

# Q = 1: Shannon Diversity
q1 <- iNEXT(combined, q=1, datatype="abundance")
print(q1) # Print iNEXT results summary

# Q = 2: Simpson Diversity
q2 <- iNEXT(combined, q=2, datatype="abundance")
print(q2)

# Calculate sample coverage for each species and find the recommended coverage level (cMax)
bottlenoseCoverage <- filter(q0$iNextEst$coverage_based, Assemblage == "Bottlenose")
bottlenoseSC <- max(bottlenoseCoverage$SC)

fkwCoverage <- filter(q0$iNextEst$coverage_based, Assemblage == "FalseKillerWhale")
fkwSC <- max(fkwCoverage$SC)

guianaCoverage <- filter(q0$iNextEst$coverage_based, Assemblage == "Guiana")
guianaSC <- max(guianaCoverage$SC)

pantropicalCoverage <- filter(q0$iNextEst$coverage_based, Assemblage == "Pantropical")
pantropicalSC <- max(pantropicalCoverage$SC)

# Determine the minimum coverage level among species (cMax)
cMax <- min(bottlenoseSC, fkwSC, guianaSC, pantropicalSC)
print(cMax)

# Estimate diversity for Q values at the common coverage level (cMax)
SC <- estimateD(combined, datatype = "abundance", base="coverage", level=cMax, conf=0.95) 
SC <- SC[order(SC$Assemblage),]
print(SC)

# Run iNEXT for Q values 0, 1, and 2, with an endpoint of 500 for extrapolation
all <- iNEXT(combined, q=c(0, 1, 2), datatype="abundance", endpoint=500)
print(all)

# Estimate diversity at the common coverage level for comparison
out <- estimateD(combined, q=c(0,1,2), datatype = "abundance", base = "coverage", level = cMax, conf=0.95)
print(out)
out <- out[order(out$Assemblage),]
print(out)

# Populate results table with diversity estimates
results[1,1] <- out$qD[1] # Bottlenose - Richness
results[1,2] <- out$qD[2] # Bottlenose - Shannon
results[1,3] <- out$qD[3] # Bottlenose - Simpson

results[2,1] <- out$qD[4] # FalseKillerWhale - Richness
results[2,2] <- out$qD[5] # FalseKillerWhale - Shannon
results[2,3] <- out$qD[6] # FalseKillerWhale - Simpson

results[3,1] <- out$qD[7] # Guiana - Richness
results[3,2] <- out$qD[8] # Guiana - Shannon
results[3,3] <- out$qD[9] # Guiana - Simpson

results[4,1] <- out$qD[10] # Pantropical - Richness
results[4,2] <- out$qD[11] # Pantropical - Shannon
results[4,3] <- out$qD[12] # Pantropical - Simpson

# Plotting iNEXT results with different facets and color variables
ggiNEXT(all, type=1, facet.var="Assemblage")
ggiNEXT(all, type=1, facet.var="Order.q", color.var="Assemblage")
ggiNEXT(all, type=2, facet.var="None", color.var="Assemblage")
ggiNEXT(all, type=3, facet.var="Assemblage")
ggiNEXT(all, type=3, facet.var="Order.q", color.var="Assemblage")


# Coupon collector's ---------------------------------
# Define the number of distinct whistle types (coupons) for each species
num_coupons_bottlenose <- 120
num_coupons_falsekillerwhale <- 116
num_coupons_guiana <- 118
num_coupons_pantropical <- 120

# Function to simulate the coupon collector's problem for a given number of coupons
simcollect <-function(n) {
  coupons <- 1:n # Set of coupons
  collect <- numeric(n)
  nums <- 0
  while (sum(collect) < n) {
    i <- sample(coupons, 1) # Randomly sample a coupon
    collect[i] <- 1 # Mark the coupon as collected
    nums <- nums + 1 # Increment the draw count
  }
  nums # Return the number of draws needed to collect all coupons
}

# Simulate the coupon collection process for each species
trials <- 10000
bottlenose_simlist <- replicate(trials, simcollect(num_coupons_bottlenose))
results[1,4] <- mean(bottlenose_simlist) # Average draws for Bottlenose

falsekillerwhale_simlist <- replicate(trials, simcollect(num_coupons_falsekillerwhale))
results[2,4] <- mean(falsekillerwhale_simlist) # Average draws for False Killer Whale

guiana_simlist <- replicate(trials, simcollect(num_coupons_guiana))
results[3,4] <- mean(guiana_simlist) # Average draws for Guiana Dolphin

pantropical_simlist <- replicate(trials, simcollect(num_coupons_pantropical))
results[4,4] <- mean(pantropical_simlist) # Average draws for Pantropical Dolphin


# CAPTURE-RECAPTURE ------------------------------

# Define a function to set up capture data for analysis
capture_setup <- function(n) {
  capture_data <- dt %>% filter(species == n) %>% select(c(category, Recording))
  matrix <- matrix(0, nrow = length(unique(capture_data$category)), ncol = length(unique(capture_data$Recording)))
  
  for (i in 1:nrow(matrix)) {
    id <- unique(capture_data$category)[i] # Each row represents a unique category
    captures <- capture_data$Recording[capture_data$category == id] # Find captures for each category
    matrix[i, captures] <- 1 # Mark captures in the matrix
  }
  matrix # Return the capture matrix
}

# Create capture matrices for each species
bottlenose_matrix <- capture_setup("Bottlenose")
falsekillerwhale_matrix <- capture_setup("FalseKillerWhale")
guiana_matrix <- capture_setup("Guiana")
pantropical_matrix <- capture_setup("Pantropical")

# Perform capture-recapture analysis using closed population models for each species
bottlenose_captures <- closedp(bottlenose_matrix)
results[1,5] <- bottlenose_captures$results[2] # Capture-Recapture estimate for Bottlenose

falsekillerwhale_captures <- closedp(falsekillerwhale_matrix)
results[2,5] <- falsekillerwhale_captures$results[2] # Capture-Recapture estimate for False Killer Whale

guiana_captures <- closedp(guiana_matrix)
results[3,5] <- guiana_captures$results[2] # Capture-Recapture estimate for Guiana Dolphin

pantropical_captures <- closedp(pantropical_matrix)
results[4,5] <- pantropical_captures$results[2] # Capture-Recapture estimate for Pantropical Dolphin

# Transpose results data frame for plotting
results_t <- t(results)
results_t <- as.data.frame(results_t)

# Define labels for diversity metrics
labels <- c("Species Richness", "Shannon Diversity", "Simpson Diversity", "Coupon Collector", "Capture-Recapture")

# Plot boxplot for all diversity metrics
boxplot(results, names=labels)

# Plot boxplot for transposed results with specific colors
boxplot(results_t, col = c("#d55e00","#0072b2","#cc79a7","#330066"))

# Prepare data for ggplot
data <- data.frame(
  Species = c("Bottlenose", "FalseKillerWhale", "Guiana", "Pantropical"),
  Richness = c(68.67704, 25.90233, 46.77368, 44.43204),
  Shannon = c(25.05048, 16.90632, 24.93917, 25.20913),
  Simpson = c(8.318931, 12.563545, 13.290093, 16.182674),
  CouponCollector = c(644.3848, 618.8924, 631.4447, 643.6055),
  CaptureRecapture = c(109.27483, 37.15900, 54.59788, 60.60917)
)

# Convert data to long format for ggplot
data_long <- data %>%
  pivot_longer(-Species, names_to = "Test", values_to = "Value")

# Define color palette
colors <- c("#d55e00","#0072b2","#cc79a7","#330066")

# Create boxplot for species
species_boxplot <- ggplot(data_long, aes(x = Species, y = Value, fill = Species)) +
  geom_boxplot() +
  labs(x = "Species", y = "Predicted Repertoire Size") +
  scale_x_discrete(labels = c("Bottlenose dolphin", "False killer whale", "Guiana dolphin", "Pantropical spotted dolphin")) +
  scale_fill_manual(values=alpha(colors, 0.75)) +
  guides(fill = FALSE) +
  theme_minimal(base_size = 16) +  # Increase base size for all text elements
  theme(
    axis.title.x = element_text(size = 18),  # Increase x-axis title size
    axis.title.y = element_text(size = 18),  # Increase y-axis title size
    axis.text = element_text(size = 16)  # Increase axis text size
  )

# Create boxplot without outliers
species_boxplot_outlierrm <- ggplot(data_long, aes(x = Species, y = Value, fill = Species)) +
  geom_boxplot(outlier.shape = NA) +
  labs(x = "Species", y = "Predicted Repertoire Size") +
  scale_x_discrete(labels = c("Bottlenose dolphin", "False killer whale", "Guiana dolphin", "Pantropical spotted dolphin")) +
  scale_fill_manual(values=alpha(colors, 0.75)) +
  coord_cartesian(ylim=c(0, 150)) +
  guides(fill = FALSE) +
  theme_minimal(base_size = 16) +  # Increase base size for all text elements
  theme(
    axis.title.x = element_text(size = 18),  # Increase x-axis title size
    axis.title.y = element_text(size = 18),  # Increase y-axis title size
    axis.text = element_text(size = 16)  # Increase axis text size
  )

# Create boxplot for tests
test_boxplot <- ggplot(data_long, aes(x = Test, y = Value)) +
  geom_boxplot() +
  labs(x = "Diversity Metric", y = "Predicted Repertoire Size") +
  scale_x_discrete(labels=c("Capture-Recapture", "Coupon Collector", "Species Richness (q=0)", "Shannon diversity (q=1)", "Simpson Diversity (q=2)")) +
  theme_minimal(base_size = 16) +  # Increase base size for all text elements
  theme(
    axis.title.x = element_text(size = 18),  # Increase x-axis title size
    axis.title.y = element_text(size = 18),  # Increase y-axis title size
    axis.text = element_text(size = 16)  # Increase axis text size
  )

# Display the plots
print(species_boxplot)
print(species_boxplot_outlierrm)
print(test_boxplot)

###### COMPARISON USING SPADE.R ---------------------------------------------

library(SpadeR)

# Summarize abundance by category and species
new_dt <- dt %>% group_by(category, species) %>% summarize(Abundance=n())

# Reshape the data to wide format for species abundance comparison
abundance_f <- new_dt %>% pivot_wider(names_from = species, values_from = Abundance, values_fill = 0)
abundance_f <- subset(abundance_f, select = -c(category))
abundance <- as.list(abundance_f)

# Perform similarity analysis for multiple assemblages using SpadeR
SimilarityMult(abundance, datatype = "abundance", q=1, goal = "relative")
