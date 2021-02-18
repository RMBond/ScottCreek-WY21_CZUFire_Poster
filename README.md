Scott Creek CZU Fire 2021 SRF Poster Notes
================
18 February, 2021

  - [Introduction](#introduction)
  - [Next Steps](#next-steps)
  - [WQ Data](#wq-data)
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
    salinity, turbidity, (and other) every half hour.

2.  Pebble count data … <span style="color:red">still need to enter
    Autumn 2020 and collect and enter Spring 2021 data.</span>

## Next Steps

1.  The inital WQ data csv file isn’t in an easily readable format. We
    will need to do some formatting in excel (not ideal) to separate the
    data columns.

2.  Collect next round of pebble count data AND do all of the data
    entry.

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
