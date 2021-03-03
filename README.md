Scott Creek CZU Fire 2021 SRF Poster Notes
================
03 March, 2021

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
    <span style="color:purple">*Scott\_Creek\_Weir\_Hydrolab\_20210303.csv*</span>
    datafile contains a snippbet (incomplete dataset) of the water
    quality data collected by the HYDROLAB (S/N 66279, model DS5X). The
    unit is installed directly above the weir. It collects depth, temp,
    salinity, turbidity, (and other) every half hour. This file be
    updated as new downloads are completed up untill the time of the
    poster. Note there is some column renaming done before importing the
    dataset into r.

2.  The <span style="color:purple">*Gagedata\_XXX.csv*</span> datafile
    contains a portion of the stage(timestamp and ft) data. The unit is
    installed near the Archibald Creek consluence with the mainstem.
    While we won’t be converting stage to discharge (we need a new
    rating curve), it will be helpful for visualizing the hyrograph and
    relate this to the WQ data. Unfortunately this file is missing WY20
    data

3.  Pebble count data … <span style="color:red">still need to enter
    Autumn 2020 and collect and enter Spring 2021 data.</span>

## Next Steps

1.  Continue to update WQ data csv file as needed.

2.  Plot Hydrograph - Missing data between 12/4/19 and 12/4/20 (SP
    emailed about issue)\!\! RB is working on this. It’s likely we will
    not be presenting this data and will use the pressure data in the WQ
    dataset as a proxy.

3.  Enter data from both rounds of pebble counts into spreadsheet. AC
    and MA can help with this.

## WQ Data

Dataset name = wq

Variable (column) description:

  - Date = date
  - TS = Timestamp
  - Temp\_C = Water Temperature \[\*C\]
  - TurbSC\_NTU = Turbidity \[NTU\]
  - Dep100\_m = Water depth (think height of water column) \[m\]
  - pH = pH
  - Sal\_ppt = Salinity \[parts per thousand\]
  - LDO\_mg\_l = Dissolved Oxygen \[mg/L\]

<!-- end list -->

``` r
str(wq)
#> 'data.frame':    2779 obs. of  8 variables:
#>  $ Date      : Date, format: "2020-12-30" "2020-12-30" ...
#>  $ TS        : POSIXct, format: "2020-12-30 14:00:00" "2020-12-30 14:30:00" ...
#>  $ Temp_C    : num  20.1 19.6 19.8 19.9 20 ...
#>  $ TurbSC_NTU: num  2.1 1.3 0 0 0 0 0 0 0 0 ...
#>  $ Dep100_m  : num  2.24 2.24 2.17 2.18 2.17 2.18 2.19 2.2 2.2 2.2 ...
#>  $ pH        : num  6.85 6.72 6.76 6.77 6.78 6.78 6.78 6.77 6.77 6.76 ...
#>  $ Sal_ppt   : num  0.24 0.25 0.24 0.24 0.25 0.25 0.25 0.25 0.25 0.25 ...
#>  $ LDO_mg_l  : num  9.39 9.35 9.24 9.13 9.13 9.14 9.1 9.09 9.05 9.08 ...
```

![](readme-figs/WQ%20Plotting-1.png)<!-- -->

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
