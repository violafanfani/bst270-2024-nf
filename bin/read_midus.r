#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

print(getwd())

# loading required packages
library("tidyverse")



# parsing input parameters for convenience
OPTIMISM_FILENAME = args[1]
BIOMARKER_FILENAME = args[2]
OUTPUT_FILENAME = args[3]
BASEDIR = args[4]

source(paste(BASEDIR,"/bin/rfunctions/filter_lipid.R", sep = ''))
source(paste(BASEDIR,"/bin/rfunctions/filter_confounders.R", sep = ''))
source(paste(BASEDIR,"/bin/rfunctions/filter_pathway.R", sep = ''))
source(paste(BASEDIR,"/bin/rfunctions/filter_optimism.R", sep = ''))


print(paste("READING: ", OPTIMISM_FILENAME," and " ,BIOMARKER_FILENAME))


# Read data
load(OPTIMISM_FILENAME)
load(BIOMARKER_FILENAME)

# Inner join of tables
data = inner_join(da04652.0001, da29282.0001, by = c("M2ID", "M2FAMNUM"),suffix = c('','.2'))

print(paste("At the beginning there are: ", nrow(data)," rows"))

# Filter data for optimism columns
data_after_fo = data %>% filter_optimism()

optimism_columns <- c('B1SORIEN','B1SE10A', 'B1SE10B', 'B1SE10C', 'B1SE10D', 'B1SE10E','B1SE10F')
data_after_fo2 <- data_after_fo %>%
    drop_na(any_of(optimism_columns))

print(paste("After filtering for optimism there are: ", nrow(data_after_fo2)," rows"))

# Filter data, remove lipids missing rows
lipid_columns = c("B4BCHOL", "B4BTRIGL", "B4BHDL", "B4BLDL")
data_after_fl = data_after_fo2 %>% filter_lipid()

print(paste("After filtering for lipids there are: ", nrow(data_after_fl)," rows"))

# Filter data, wrangle pathway data and remove NA rows
data_after_fp = filter_pathway(data_after_fl)
pathway_columns = c("B4PBMI", "alcohol_consumption", "smoking_status", "reg_exercise","score_sum")
print(paste("After filtering for pathways there are: ", nrow(data_after_fp)," rows"))

# Filter data, remove confounders missing rows
confounder_columns = c('B1PB1','B1STINC1','B4ZB1SLG','B1SCHROX','B4H26','B4H33','B4H25','B4PBMI','B1SNEGAF')
data_after_fc = filter_confounders(data_after_fp, confounder_columns)
print(paste("After filtering for confounders there are: ", nrow(data_after_fc)," rows"))

other_cols = c("B1PAGE_M2", "B1PRSEX", "B1PF7A", "B1PA25IN",  "B1PA24C")

all_columns = c(optimism_columns, lipid_columns, pathway_columns, confounder_columns, other_cols)

# Final dataset
final_data = data_after_fc[,all_columns]

# Save data
write.csv(final_data, OUTPUT_FILENAME, row.names=FALSE)
print(paste("SAVED TO: ",OUTPUT_FILENAME))
