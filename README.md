Scott Creek CZU Fire 2021 SRF Poster Notes
================
25 March, 2021

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
    <span style="color:purple">*Scott\_Creek\_Pebble\_20210319.csv*</span>
    datafile consists of pebble counts at 23 transects accrost the
    watershed (6 eFishing sites with 3 transects each, and 5 additional
    pebble count only transects) which were repeated twice (Autumn 2020
    & Winter 2021). AC and MA entered and QC’ed the data.

## Next Steps

1.  Decide on which WQ parameters to present and continue to update WQ
    data csv file as needed.

2.  RB is working on code for making pebble count summaries and
    potential plotting.

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

Goals:

1.  Compare how different surface summary statistics (i.e. Dx) changed
    after the “first flush” at 1.A each site and 1.B longitudinally
    along the mainstem and

2.  Estimate the change in the amount of surface fines at each transect
    (reported as % change over time). Note: The cuttoff for “fines” in
    the litterature is a bit ambiguous. For now we will stick with
    “fines” meaning \<6mm (though \<8mm could also been used).

<!-- end list -->

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
#> grouped_df [736 x 8] (S3: grouped_df/tbl_df/tbl/data.frame)
#>  $ Date          : Date[1:736], format: "2020-11-23" "2020-11-23" ...
#>  $ Site          : Factor w/ 11 levels "Big Creek eFishing",..: 4 4 4 5 5 5 11 11 11 3 ...
#>  $ Transect      : num [1:736] 1 2 3 1 2 3 1 2 3 1 ...
#>  $ Round         : Factor w/ 2 levels "1","2": 1 1 1 1 1 1 1 1 1 1 ...
#>  $ Long_Station  : num [1:736] 11 11 11 1 1 1 6 6 6 7 ...
#>  $ Size_class_mm : num [1:736] 1.9 1.9 1.9 1.9 1.9 1.9 1.9 1.9 1.9 1.9 ...
#>  $ Category_total: num [1:736] 53 48 42 50 19 41 22 23 20 35 ...
#>  $ Percent_finer : num [1:736] 0.53 0.48 0.42 0.5 0.19 ...
#>  - attr(*, "groups")= tibble [47 x 4] (S3: tbl_df/tbl/data.frame)
#>   ..$ Round   : Factor w/ 2 levels "1","2": 1 1 1 1 1 1 1 1 1 1 ...
#>   ..$ Site    : Factor w/ 11 levels "Big Creek eFishing",..: 1 1 1 2 2 2 3 3 3 4 ...
#>   ..$ Transect: num [1:47] 1 2 3 1 2 3 1 2 3 1 ...
#>   ..$ .rows   : list<int> [1:47] 
#>   .. ..$ : int [1:16] 13 59 105 151 197 243 289 335 381 427 ...
#>   .. ..$ : int [1:16] 14 60 106 152 198 244 290 336 382 428 ...
#>   .. ..$ : int [1:16] 15 61 107 153 199 245 291 337 383 429 ...
#>   .. ..$ : int [1:16] 16 62 108 154 200 246 292 338 384 430 ...
#>   .. ..$ : int [1:16] 17 63 109 155 201 247 293 339 385 431 ...
#>   .. ..$ : int [1:16] 18 64 110 156 202 248 294 340 386 432 ...
#>   .. ..$ : int [1:15] 10 56 102 148 194 240 332 378 424 470 ...
#>   .. ..$ : int [1:16] 11 57 103 149 195 241 287 333 379 425 ...
#>   .. ..$ : int [1:16] 12 58 104 150 196 242 288 334 380 426 ...
#>   .. ..$ : int [1:16] 1 47 93 139 185 231 277 323 369 415 ...
#>   .. ..$ : int [1:16] 2 48 94 140 186 232 278 324 370 416 ...
#>   .. ..$ : int [1:16] 3 49 95 141 187 233 279 325 371 417 ...
#>   .. ..$ : int [1:16] 4 50 96 142 188 234 280 326 372 418 ...
#>   .. ..$ : int [1:16] 5 51 97 143 189 235 281 327 373 419 ...
#>   .. ..$ : int [1:16] 6 52 98 144 190 236 282 328 374 420 ...
#>   .. ..$ : int [1:16] 19 65 111 157 203 249 295 341 387 433 ...
#>   .. ..$ : int [1:16] 20 66 112 158 204 250 296 342 388 434 ...
#>   .. ..$ : int [1:16] 21 67 113 159 205 251 297 343 389 435 ...
#>   .. ..$ : int [1:16] 22 68 114 160 206 252 298 344 390 436 ...
#>   .. ..$ : int [1:16] 23 69 115 161 207 253 299 345 391 437 ...
#>   .. ..$ : int [1:16] 7 53 99 145 191 237 283 329 375 421 ...
#>   .. ..$ : int [1:16] 8 54 100 146 192 238 284 330 376 422 ...
#>   .. ..$ : int [1:16] 9 55 101 147 193 239 285 331 377 423 ...
#>   .. ..$ : int [1:16] 30 76 122 168 214 260 306 352 398 444 ...
#>   .. ..$ : int [1:16] 31 77 123 169 215 261 307 353 399 445 ...
#>   .. ..$ : int [1:16] 32 78 124 170 216 262 308 354 400 446 ...
#>   .. ..$ : int [1:16] 33 79 125 171 217 263 309 355 401 447 ...
#>   .. ..$ : int [1:16] 34 80 126 172 218 264 310 356 402 448 ...
#>   .. ..$ : int [1:16] 35 81 127 173 219 265 311 357 403 449 ...
#>   .. ..$ : int [1:16] 39 85 131 177 223 269 315 361 407 453 ...
#>   .. ..$ : int [1:16] 40 86 132 178 224 270 316 362 408 454 ...
#>   .. ..$ : int [1:16] 41 87 133 179 225 271 317 363 409 455 ...
#>   .. ..$ : int [1:16] 27 73 119 165 211 257 303 349 395 441 ...
#>   .. ..$ : int [1:16] 28 74 120 166 212 258 304 350 396 442 ...
#>   .. ..$ : int [1:16] 29 75 121 167 213 259 305 351 397 443 ...
#>   .. ..$ : int [1:16] 24 70 116 162 208 254 300 346 392 438 ...
#>   .. ..$ : int [1:16] 25 71 117 163 209 255 301 347 393 439 ...
#>   .. ..$ : int [1:16] 26 72 118 164 210 256 302 348 394 440 ...
#>   .. ..$ : int [1:16] 42 88 134 180 226 272 318 364 410 456 ...
#>   .. ..$ : int [1:16] 43 89 135 181 227 273 319 365 411 457 ...
#>   .. ..$ : int [1:16] 44 90 136 182 228 274 320 366 412 458 ...
#>   .. ..$ : int [1:16] 45 91 137 183 229 275 321 367 413 459 ...
#>   .. ..$ : int [1:16] 46 92 138 184 230 276 322 368 414 460 ...
#>   .. ..$ : int [1:16] 36 82 128 174 220 266 312 358 404 450 ...
#>   .. ..$ : int [1:16] 37 83 129 175 221 267 313 359 405 451 ...
#>   .. ..$ : int [1:16] 38 84 130 176 222 268 314 360 406 452 ...
#>   .. ..$ : int 286
#>   .. ..@ ptype: int(0) 
#>   ..- attr(*, ".drop")= logi TRUE
```

**Cumulative percent finer plots for the eFishing sites**

Each eFishing site plot: each panel (facet) is a transect and line color
denotes the two survey rounds (tan is before winter, blue is after first
flush). The starting place and slope of each line gives you an idea of
the sediment distribution. “Shifts in the lower end of the pebble count
cumulative frequency curves are indicative of significant increases in
streambed fines” (Potyondy and Hardy 1994). If the blue line starts
above the tan line, the surface sediment became finer after the first
flush.

Potyondy and Hardy (1994) reccomend, “statistical comparison of particle
size distributions can be done with 2 x 2 contingency tables (number of
pebbles less than 6 mm versus the number of pebbles greater than or
equal to 6 mm) and the likelihood ratio Chi-square statistic to compare
one frequency distribution with another (King and Potyondy, 1993).”

``` r

test.bc <- pc %>% 
  filter(Site == "Big Creek eFishing")

#Big Creek Plot
bc <- ggplot(test.bc, aes(Size_class_mm, Percent_finer, color = Round)) +
  geom_line() +
  facet_grid(Transect ~ .) +
  scale_x_log10(name = "Partical size [Log10(mm)]") +
  scale_y_continuous(name = "Cumulative percent finer", limits = c(0,1), expand = c(0,.1)) +
  scale_color_manual(values = c("#a6611a", "#018571")) +
  theme_classic() +
  ggtitle("Big Creek")

test.um <- pc %>% 
  filter(Site == "Upper Mainstem eFishing")

#Upper Mainstem Plot - Not much change in the lower watershed. 
um <- ggplot(test.um, aes(Size_class_mm, Percent_finer, color = Round)) +
  geom_line() +
  facet_grid(Transect ~ .) +
  scale_x_log10(name = "Partical size [Log10(mm)]") +
  scale_y_continuous(name = "", limits = c(0,1), expand = c(0,.1)) +
  scale_color_manual(values = c("#a6611a", "#018571")) +
  theme_classic() +
  ggtitle("Upper Mainstem")

#Put plots together using patchwork
bc + um +
  plot_layout(guides = 'collect') & 
  theme(legend.position = 'bottom') 
```

![](README_files/figure-gfm/Big%20Creek%20and%20the%20Lower%20mainstem%20quick%20cumulative%20percent%20finer%20plots-1.png)<!-- -->

``` r
  # plot_annotation(caption = 'If the blue line starts above the tan line, it means the surface sediment became finer after the first flush.')
  
```

**Find gransize at percentiles**

Colin Nicol has generously shared his code to help with this. He created
a function which interpolates a straight line between the two points
nearest to the desired percentile `Dx`. Using the data provided, the
function looks for the minimum grain size where the percent finer is
greater than `Dx`. Then it calculates the slope between those two lines.
From here, it uses the slope and the `rise` to get to 50% to calculate a
`run` (distance on the x-axis `grain size` we need to move from the
known point to `D50`).

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

#Call in what you want to calculate. In this case its the median grain size (D50) of the test dataset (one site). 

calculate_dx(50, pc.test$Size_class_mm, pc.test$Percent_finer)
#> [1] 8.825

#Note, it will give you an error if the first category (i.e. <2mm) is greater than the percential you want to calculate.

# calculate_dx(16, pc.test$Size_class_mm, pc.test$Percent_finer) #error generated becuase you want to calculate the D16 and <2mm is 40% of the sample.

#Once we have this function set up, loop through D16, D50 and D84 for the one site.
dxs <- c(16, 50, 84) # choose which percentiles to calculate (e.g. D16, D50, D84)

names(dxs) <- paste0('d', dxs)

sapply(dxs, calculate_dx, size = pc.test$Size_class_mm, prcnt_finer = pc.test$Percent_finer)
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



# Calculate summary stats for multiple transects all at once
#Test dataset
pc2.test <- pc.test %>%
  summarize(
    d50 = calculate_dx(50, size = pc.test$Size_class_mm, prcnt_finer = pc.test$Percent_finer),
    d84 = calculate_dx(84, size = pc.test$Size_class_mm, prcnt_finer = pc.test$Percent_finer))

####START HERE####
#NOT WORKING FOR THE WHOLE DATASET!
####

# pc2 <- pc %>%
#   # group_by(Site, Transect, Round) %>% # Creates a unique grouping variable
#   summarize(
#             # d16 = calculate_dx(16, size = pc.test$Size_class_mm, prcnt_finer = pc.test$Percent_finer),
#     d50 = calculate_dx(50, size = pc$Size_class_mm, prcnt_finer = pc$Percent_finer),
#     d84 = calculate_dx(84, size = pc$Size_class_mm, prcnt_finer = pc$Percent_finer))
```

**Percent fines (\<6mm) along the mainstem**

Plot following Potyondy and Hardy (1994) structure (% surface fines by
longitude).

``` r

pc3.mainstem.fines <- pc %>% 
  filter(Size_class_mm == 5.6) %>% #select the fines size class.
    filter(Long_Station < 8) %>% #mainstem stations
  filter(Transect == 0 | Transect == 2) #use T2 (midpoint) for each eFishing reach.

a <- ggplot(pc3.mainstem.fines, aes(x = Long_Station, y = Percent_finer, color = Round)) +
  geom_line() +
  geom_point() +
scale_y_continuous(name = "Percent surface fines", limits = c(0,1.0), expand = c(0,0)) +
scale_x_continuous(name = "Station Number", limits = c(1,7), breaks = seq(0,7,1)) +
scale_color_manual(values = c("#a6611a", "#018571"), labels = c("Before", "After")) +
theme_classic() +
  geom_hline(yintercept = 0, lty = 2) +
  labs(title = "A") +
       # subtitle = "Flow is from right (upstream) to left (downstream)") +
       # caption = "The meainstem between Big and Little Creeks (Station 3) and the upper watershed \n (Stations 6 and 7) had the biggest increases in fine sediment.")
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "top",
        legend.title = element_blank())
```

**Caculate change in % fines (\<6mm) for each transect**

Start by summarising the % fines at each transect and then subtract
round 1 from round 2. Poitive numbers mean the channel bed has gotten
finer and negative numbers mean the bed has gotten more course.

``` r

# #Subset data by Round
# pc3.r1 <- pc %>%
#   filter(Round == 1) %>% #Round 1 data
#   filter(Size_class_mm == 5.6) #focus on the 5.6 size class for each transect
# 
# 
# pc3.r2 <- pc %>%
# filter(Round == 2) %>% #Round 2 data
#   filter(Size_class_mm == 5.6) #focus on the 5.6 size class for each transect
# 
# #Spread data into long format to calculate % change
# pc3 <- full_join(pc3.r1, pc3.r2, by = c("Site", "Transect")) %>% #Joins the two rounds of data
#   mutate(fines_per_change = Percent_finer.y - Percent_finer.x) %>% #Subract round 1 from round 2. A positive number means an increase in fines after the first flush.
#   mutate(Long_Station = Long_Station.x) %>% #relabeling station for clarity
#   select(Site, Transect, Long_Station, fines_per_change)
# 
# #Plot % fines change over longitudinal station distance
# 
# #Subset data by mainstem vs tributary stations (See above for station number key)
# pc3.mainstem <- pc3 %>%
#   filter(Long_Station < 8) %>%
#   filter(Transect == 0 | Transect == 2)
# 
# pc3.bigcreek <- pc3 %>%
#   filter(Long_Station > 7 & Long_Station < 11) %>%
#   filter(Transect == 0 | Transect == 2)
# 
# pc3.littlecreek <- pc3 %>%
#   filter(Long_Station == 11) %>%
#   filter(Transect == 0 | Transect == 2)
# 
# #Subset efishing reaches to make ranges for plot
# stattest <- pc3 %>%
#   filter(Long_Station == 7)
# 
# #Mainstem plot
# 
# b <- ggplot(pc3.mainstem, aes(x = Long_Station, y = fines_per_change)) +
#   geom_line() +
#   geom_point() +
# scale_y_continuous(name = "Change in percent fines", limits = c(-0.2,0.45), breaks = seq(-0.2,0.45,.1), expand = c(0,0)) +
# scale_x_continuous(name = "Station Number", limits = c(1,7), breaks = seq(0,7,1)) +
# theme_classic() +
#   geom_hline(yintercept = 0, lty = 2) +
#   # geom_segment(x = 1, y = -0.13, xend = 1, yend = 0.08, lty = 3) + #variation in Station 1
#   # geom_segment(x = 6, y = 0.12, xend = 6, yend = 0.25, lty = 3) + #variation in Station 6
#   # geom_segment(x = 7, y = -0.11, xend = 7, yend = 0.3857, lty = 3) + #variation in Station 7
# labs(title = "B")
#   # labs(title = "Change in percent fines (<6mm) along the mainstem",
#   #      subtitle = "Flow is from right (Upstream) to left (Downstream)",
#   #      caption = "The meainstem between Big and Little Creeks (Station 3) and the upper watershed \n (Stations 6 and 7) had the biggest increases in fine sediment. \n Dotted vertical lines are ranges at the eFishing sites.")
# 
# a / b
```

**Boxplots and stat tests of percent surface fines (before and after
“first flush”)**

``` r

#Boxplot of percent surface fines using all sites/transects

 pc4.fines <- pc %>% 
  filter(Size_class_mm == 5.6)
 
 plot.pc4.fines.all <- ggplot(pc4.fines, aes(x = Round, y = Percent_finer)) +
   geom_boxplot() +
   scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                      expand = c(0,0))  +
  ggtitle("All sites")
 
#Boxplot of percent surface fines on mainstem
 pc4.fines.mainstem <- pc %>% 
  filter(Size_class_mm == 5.6) %>% 
  filter(Long_Station < 8)

 plot.pc4.fines.mainstem <- ggplot(pc4.fines.mainstem, aes(x = Round, y = Percent_finer)) +
   geom_boxplot(fill = c("#a6611a", "#018571")) +
   scale_x_discrete(name = "", limits = c("1","2"), labels = c("Before", "After")) +
   scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                      expand = c(0,0)) +
   theme_classic() +
   ggtitle("Scott Creek Mainstem (n=13)")
 
#Boxplot of percent surface fines on Big Creek
 pc4.fines.bc <- pc %>% 
  filter(Size_class_mm == 5.6) %>% 
  filter(Long_Station > 7 & Long_Station < 11)

 plot.pc4.fines.bc <- ggplot(pc4.fines.bc, aes(x = Round, y = Percent_finer)) +
   geom_boxplot(fill = c("#a6611a", "#018571")) +
   scale_x_discrete(name = "", limits = c("1","2"), labels = c("Before", "After")) +
   scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                      expand = c(0,0)) +
   theme_classic() +
   theme(axis.title.y = element_blank()) +
   ggtitle("Big Creek (n=7)")
   
 
#Boxplot of percent surface fines on Little Creek
 pc4.fines.lc <- pc %>% 
  filter(Size_class_mm == 5.6) %>% 
  filter(Long_Station == 11)

 plot.pc4.fines.lc <- ggplot(pc4.fines.lc, aes(x = Round, y = Percent_finer)) +
   geom_boxplot(fill = c("#a6611a", "#018571")) +
   scale_x_discrete(name = "", limits = c("1","2"), labels = c("Before", "After")) +
   scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                      expand = c(0,0)) +
   theme_classic() +
   theme(axis.title.y = element_blank()) +
   ggtitle("Little Creek (n=3)")
 
#Put plots together using patchwork
plot.pc4.fines.mainstem +  plot.pc4.fines.bc +  plot.pc4.fines.lc
```

![](README_files/figure-gfm/Boxplot%20of%20percent%20surface%20fines-1.png)<!-- -->

``` r


#Variation in Percent Fines for each eFishing Site starting with pc4.fines

#Grab the eFishing sites
pc4.efishing <- pc4.fines %>% 
  filter(grepl('eFishing', Site)) #using grepl to select all sites with "efishing" in the name 

#Tell r Sites will be in a specific order.
pc4.efishing$Site <- factor(pc4.efishing$Site, levels = c("Dog eFishing","Upper Mainstem eFishing","Lower Mainstem eFishing","Big Creek Powerhouse eFishing","Big Creek eFishing", "Little Creek eFishing"),ordered = TRUE)

#Scatterplot to see the variation (3 transects) in percent fines for each eFishing Site.
ggplot(pc4.efishing, aes(x = Site, y = Percent_finer, color = Round)) +
  geom_jitter(width = 0.1) +
  scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                      expand = c(0,0)) +
  scale_color_manual(values = c("#a6611a", "#018571"), labels = c("Before", "After")) +
  theme_classic() +
  theme(legend.position = "top",
        legend.title = element_blank())
```

![](README_files/figure-gfm/Boxplot%20of%20percent%20surface%20fines-2.png)<!-- -->

``` r



#Need to figure out if we are using T Tests or Chi-squared test for independance?

#Before running the t tests we need to think about independance (repeated measures??. 

#Mainstem
 pc4.fines.mainstem.r1 <-  pc4.fines.mainstem %>% 
     filter(Round == 1) %>% #Round 1 data  
     select(Percent_finer)
#> Adding missing grouping variables: `Round`, `Site`, `Transect`
 
pc4.fines.mainstem.r2 <-  pc4.fines.mainstem %>% 
     filter(Round == 2) %>% #Round 2 data
     select(Percent_finer)
#> Adding missing grouping variables: `Round`, `Site`, `Transect`

# t.test( pc4.fines.mainstem.r1$Percent_finer,  pc4.fines.mainstem.r2$Percent_finer, alternative = "two.sided") #May need to adjust the alternative to "greater than".

# Big Creek

 pc4.fines.bc.r1 <-  pc4.fines.bc %>% 
     filter(Round == 1) %>% #Round 1 data  
     select(Percent_finer)
#> Adding missing grouping variables: `Round`, `Site`, `Transect`
 
pc4.fines.bc.r2 <-  pc4.fines.bc %>% 
     filter(Round == 2) %>% #Round 2 data
     select(Percent_finer)
#> Adding missing grouping variables: `Round`, `Site`, `Transect`

# t.test( pc4.fines.bc.r1$Percent_finer,  pc4.fines.bc.r2$Percent_finer, alternative = "two.sided") #May need to adjust the alternative to "greater than".

#Little Creek
 pc4.fines.lc.r1 <-  pc4.fines.lc %>% 
     filter(Round == 1) %>% #Round 1 data  
     select(Percent_finer)
#> Adding missing grouping variables: `Round`, `Site`, `Transect`
 
pc4.fines.lc.r2 <-  pc4.fines.lc %>% 
     filter(Round == 2) %>% #Round 2 data
     select(Percent_finer)
#> Adding missing grouping variables: `Round`, `Site`, `Transect`

# t.test( pc4.fines.lc.r1$Percent_finer,  pc4.fines.lc.r2$Percent_finer, alternative = "two.sided") #May need to adjust the alternative to "greater than".
```

## Figure Output

The <span style="color:purple">*Figure*</span> folder contains the
figures used in the poster.

1.
