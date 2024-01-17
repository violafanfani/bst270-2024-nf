#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# parsing input parameters for convenience
MIDUS_FILENAME = args[1]
OUTPUT_FIGURE = args[2]
BASEDIR = args[3]

source(paste(BASEDIR,"/bin/rfunctions/fig1plot.R", sep = ''))

# loading required packages
library("tidyverse")
library("ggplot2")

# Loading data, now we are using tidy own data
#read_csv(readr_example("mtcars.csv"))
midus <- read_csv(MIDUS_FILENAME)

# plotting ggplot2 own data
myplot <- gen_fig1(midus)

# saving output to file
ggsave(OUTPUT_FIGURE, plot = myplot, width = 4, height = 3)