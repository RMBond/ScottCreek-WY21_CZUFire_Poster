###############################################
##
## Script name: 4_eFishing_Data.R
##
## Goals: 1. Generate population estimates and CI using FSA package.
##
##        2. Plot population estimates over time.
##
## Note: See https://github.com/RMBond/ScottCreek-WY21_CZUFire_Poster for project information.
##
###############################################

#Load packages
library(tidyverse)
library(dplyr)
library(lubridate)
library(FSA) #install.packages("FSA") # this will take a while.
library(patchwork)

#1. Read in the data ####

fish.dat <- read.csv("Data/eFishing_20210407.csv", sep = ",", header = T) #23 obs of 8 var. 


#2. Do some data wrangling ####

fish <- fish.dat %>% #Start formatting columns into r "tidy" structure.
  mutate(Date = mdy(Date)) #R sees dates as Year-Month-Day this tells it where to get that info from the date column.
  
#Check the data structure

str(fish)

