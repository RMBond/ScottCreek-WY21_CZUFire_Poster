###############################################
##
## Script name: 2_Hydrograph_Data.R
##
## Goal: Visualize hydrograph time-series during the "first flush". 
##       Note this data will NOT be presented in the poster due to data gaps.
##
## Note: See https://github.com/RMBond/ScottCreek-WY21_CZUFire_Poster for project information.
##
###############################################

#Load packages
library(lubridate)
library(ggplot2)
library(scales)
library(gridExtra)
library(dplyr)
options(scipen = 999)

#1. Read in the data ####

gage.dat <- read.csv("data/Gagedata_20210930.csv", h = T)#Flows up to 30 January 2021 6891 obs of 2 var.

#2. Do some data wrangling ####

gage <- gage.dat %>% #Start formatting columns into r "tidy" structure.
  mutate(DT = mdy_hm(as.character(timestamp))) %>% # clean up time data
  mutate(stage_m = stage_ft*0.3048) %>% #Convert from ft to m
  select(DT, stage_m)

str(gage)

#3. Make a basic plot ####

ggplot(gage,aes(DT,stage_m)) +
  geom_point() +
  scale_x_datetime(name = "",
                   date_breaks = "1 month", date_labels = ("%b")) +
  scale_y_continuous(name = "Height (m)") +
theme_classic()
