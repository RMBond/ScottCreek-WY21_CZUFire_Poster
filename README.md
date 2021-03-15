Scott Creek CZU Fire 2021 SRF Poster Notes
================
15 March, 2021

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
    relate this to the WQ data. <span style="color:red">Unfortunately
    this file is missing WY20 data (specifically data between 12/4/19
    and 12/4/20)and it’s likely we will not be presenting this data. We
    can use the pressure data in the WQ dataset as a proxy.</span>

3.  The
    <span style="color:purple">*Scott\_Creek\_Pebble\_XXX.csv*</span>
    datafile consists of two round sof pebblecounts at 23 transects
    accrost the watershed. AC and MA entered and QC’ed the data.

## Next Steps

1.  Continue to update WQ data csv file as needed.

2.  AC and MA are entering the data from both rounds of pebble counts
    into spreadsheet.

3.  RB is making pebble count summary and plotting code.

## WQ Data

Goal: Visualize WQ time-series during the “first flush”.

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

![](README_files/figure-gfm/WQ%20Plotting-1.png)<!-- -->

## Hydrograph

Goal: Visualize Hydrograph time-series during the “first flush”. Note
this data will *not* be presented in the poster.

``` r
# library(lubridate)
# library(ggplot2)
# library(scales)
# library(gridExtra)
# library(dplyr)
# options(scipen = 999)

# #Bring in datasets
# gage.dat <- read.csv("data/Gagedata_XXX.csv", h = T)#Flows up to 30 January 2021 6891 obs of 2 var.
# 
# #Clean up hydrograph data
# gage <- gage.dat %>% #Start formatting columns into r "tidy" structure.
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

Goal: 1. Compair how different surface summary statistics (i.e. Dx)
changed after the “first flush” at 1.a each site and 1.b longitudinally
along the mainstem and 2. estimate the change in the amount of surface
fines at each transect (reported as % change over time).

  - There are some example papers vizualizing pebble count data in the
    CZU fire google drive [pebble count
    folder](https://drive.google.com/drive/u/1/folders/1MwYFVTyhN1_3NMqhlwIAu8DBYOm8KzSo).

Dataset name = pc

Variable (column) description:

  - Date = Sample date (format = YYYY-MM-DD).

  - Site = Site name (“\_\_\_ eFishing” or “PCX-\_\_”).

  - Transect = Transect number (1,2,3 for eFishing sites or blank for
    PCX sites).

  - Round = Survey round (1 = Autumn 2020, 2 = Winter 2021).

  - Long\_Station = Longitude Station (1 = Lower eFishing, 2 = PCX-1, 3
    = PCX-2, 4 = PCX-4, 5 = PCX-5, 6 = Upper eFishing, 7 = Dog eFishing,
    8 = PCX-3, 9 = Big Creek eFishing, 10 = Powerhouse eFishing, 11 =
    Little Creek eFishing).

  - Size\_class\_mm = Size class (mm), gevelometer hole the pebble *did
    not* fit though.

  - Category\_total = Total number of pebbles in the size class.

  - Percent\_finer = Cumulative percent finer for each size class. This
    is used for calculating the Dx statistic.

<!-- end list -->

``` r
str(pc)
#> 'data.frame':    16 obs. of  8 variables:
#>  $ Date          : Date, format: "2021-02-24" "2021-02-24" ...
#>  $ Site          : Factor w/ 1 level "Lower eFishing": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ Transect      : int  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Round         : int  2 2 2 2 2 2 2 2 2 2 ...
#>  $ Long_Station  : num  1 1 1 1 1 1 1 1 1 1 ...
#>  $ Size_class_mm : num  1.9 2 2.8 4 5.6 8 11.3 16 22.6 32 ...
#>  $ Category_total: num  40 0 0 1 3 4 6 5 10 14 ...
#>  $ Percent_finer : num  0.404 0.404 0.404 0.414 0.444 ...
```

\#Find gransize at percentiles

Colin Nicol has generously shared his code (from previous work we did
together). Create a function which interpolates a straight line between
the two points nearest to the desired percentile `Dx`. Using the data
provided, the function looks for the minimum grain size where the
percent finer is greater than `Dx`. Then it calculates the slope between
those two lines. From here, it uses the slope and the `rise` to get to
50% to calculate a `run` (distance on the x-axis `grain size` we need to
move from the known point to `D50`).

``` r


#Pebble Count Summary Stat code from C. Nicol :)

calculate_dx <- function(dx, size, prcnt_finer) {
  # Purpose: Calculate the grainsize for a given percentile
  # Method: Interpolate a straight line between the two bounding points
  # Input:  df - Dataframe with percent finer than data, dx - desired output percentile
  
  # Output: Grainsize at dx
  
  dx <- dx/100
  
  data.frame(size = size, prcnt_finer = prcnt_finer) %>%
    mutate(abovex = min(size[prcnt_finer > dx]),
           lessx = max(size[prcnt_finer <= dx])) %>%
    filter(size %in% c(abovex, lessx)) %>%
    mutate(slope = (max(prcnt_finer) - min(prcnt_finer)) / (max(size) - min(size))) %>%
    filter(size == lessx) %>%
    mutate(run = (dx - prcnt_finer) / slope,
           dx_size = size + run,
           dx = dx * 100) %>%
    pull(dx_size)
  
}

#Call in what you want to calculate. In this case its the median grain size (D50) of the test dataset. 

calculate_dx(50, pc$Size_class_mm, pc$Percent_finer)
#> [1] 8.825

#Note, it will give you an error if the first category (i.e. <2mm) is greater than the percential you want to calculate.

calculate_dx(16, pc$Size_class_mm, pc$Percent_finer) #error generated becuase you want to calculate the D16 and <2mm is 40% of the sample.
#> Warning in max(size[prcnt_finer <= dx]): no non-missing arguments to max;
#> returning -Inf
#> numeric(0)

#Once we have this function set up, loop through D16, D50 and D84.
dxs <- c(16, 50, 84) # choose which percentiles to calculate (e.g. D16, D50, D84)

names(dxs) <- paste0('d', dxs)

sapply(dxs, calculate_dx, size = pc$Size_class_mm, prcnt_finer = pc$Percent_finer) 
#> Warning in max(size[prcnt_finer <= dx]): no non-missing arguments to max;
#> returning -Inf
#> $d16
#> numeric(0)
#> 
#> $d50
#> [1] 8.825
#> 
#> $d84
#> [1] 32.34667
```

## Figure Output

The <span style="color:purple">*Figure*</span> folder contains the
figures used in the poster.

1.
