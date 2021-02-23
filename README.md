Scott Creek CZU Fire 2021 SRF Poster Notes
================
23 February, 2021

  - [Introduction](#introduction)
  - [Next Steps](#next-steps)
  - [WQ Data](#wq-data)
  - [Hydrograph](#hydrograph)
  - [Pebble Counts](#pebble-counts)
  - [Figure Output](#figure-output)

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Introduction

This is a space to keep track of the datasets used in the 2021 SRF
poster. The goal is to visualize the “first flush” after the 2020 CZU
Fire in the Scott Creek watershed (Santa Cruz, CA). Initially we plan to
look at water quality and pebble count data.

<br>

**Dataset Descriptions**

The <span style="color:purple">*Data*</span> folder contains the
datasets used in the poster.

1.  The
    <span style="color:purple">*Scott\_Creek\_Weir\_Hydrolab\_12302020.csv*</span>
    datafile contains a snippbet (incomplete dataset) of the water
    quality data collected by the HYDROLAB (S/N 66279, model DS5X). The
    unit is installed directly above the weir. It collects depth, temp,
    salinity, turbidity, (and other) every half hour. This file be
    updated as new downloads are completed up untill the time of the
    poster.

2.  The <span style="color:purple">*Gagedata\_XXX.csv*</span> datafile
    contains a portion of the stage(timestamp and ft) data. The unit is
    installed near the Archibald Creek consluence with the mainstem.
    While we won’t be converting stage to discharge (we need a new
    rating curve), it will be helpful for visualizing the hyrograph and
    relate this to the WQ data. This file be updated as new downloads
    are completed up untill the time of the poster.

3.  Pebble count data … <span style="color:red">still need to enter
    Autumn 2020 and collect and enter Spring 2021 data.</span>

## Next Steps

1.  The inital WQ data csv file isn’t in an easily readable format. We
    will need to do some formatting in excel (not ideal) to separate the
    data columns (likely use space insted of comma).

2.  Plot Hydrograph - Missing data between 12/4/19 and 12/4/20 (SP
    emailed about issue)\!\! RB will work on this.

3.  Collect next round of pebble count data (scheduled 2/24/21) AND
    enter data from both rounds into spreadsheet. AC and MA can help
    with this.

## WQ Data

``` r

library(dplyr)
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union
library(lubridate)
#> 
#> Attaching package: 'lubridate'
#> The following object is masked from 'package:base':
#> 
#>     date
library(ggplot2)
library(patchwork)

wq.dat <- read.csv("Data/Scott_Creek_Weir_Hydrolab_12302020.csv", sep = ",", header = T) #Initial water qualiy test dataset.
```

## Hydrograph

``` r
library(lubridate)
library(ggplot2)
library(scales)
library(gridExtra)
#> 
#> Attaching package: 'gridExtra'
#> The following object is masked from 'package:dplyr':
#> 
#>     combine
library(dplyr)
options(scipen = 999)

# #Bring in datasets
# gage.dat <- read.csv("data/Gagedata_XXX.csv", h = T)#Flows up to 30 January 2021 6891 obs of 2 var.
# 
# #Clean up hydrograph data
# gage <- gage.dat %>% 
#   mutate(DT = mdy_hm(as.character(timestamp))) %>% # clean up time data
#   mutate(stage_m = stage_ft*0.3048) %>% #Convert from ft to m
#   select(DT, stage_m)
# 
# str(gage)
# 
# #Hydrograph 
# #Plot 1 - basic plot
# ggplot(gage,aes(DT,stage_m)) +
#   geom_point() +
#   scale_x_datetime(name = "",
#                    date_breaks = "1 month", date_labels = ("%b")) +
#   scale_y_continuous(name = "Height (m)") +
# theme_classic() 
```

## Pebble Counts

  - Check out this [r package on grain
    size](https://github.com/dtavern/grainsizeR) Note: it is under
    development but may be useful for some quick data viz.

  - There are some example papers vizualizing pebble count data in the
    CZU fire google drive [pebble count
    folder](https://drive.google.com/drive/u/1/folders/1MwYFVTyhN1_3NMqhlwIAu8DBYOm8KzSo).

## Figure Output

The <span style="color:purple">*Figure*</span> folder contains the
figures used in the poster.

1.
