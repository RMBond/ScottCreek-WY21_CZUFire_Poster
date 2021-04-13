###############################################
##
## Script name: 1_WQ_Data.R
##
## Goal: Visualize WQ time-series during the "first flush".
##
## Note: See https://github.com/RMBond/ScottCreek-WY21_CZUFire_Poster for project information.
##
###############################################

#Load packages
library(ggplot2)
library(dplyr)
library(lubridate)
library(patchwork)
library(xts)

#1. Read in the data ####

# wq.dat <- read.csv("Data/Scott_Creek_Weir_Hydrolab_20210303.csv", sep = ",", header = T) #Initial water qualiy test dataset.

wq.dat <- read.csv("Data/Scott_Creek_Weir_Hydrolab_20210413.csv", sep = ",", header = T) #Minor QC water qualiy dataset.


#2. Do some data wrangling ####

wq <- wq.dat %>% #Start formatting columns into r "tidy" structure.
  mutate(Date = mdy(Date)) %>% #R sees dates as Year-Month-Day this tells it where to get that info from the date column.
  mutate(Time = hms(Time)) %>% # Tells r this column is Hours:Min:Sec
  mutate(TS = as.POSIXct(Date + Time)) %>% #making a new column with timestamp by combining Date and Time
  select(Date, TS, Temp_C, TurbSC_NTU, Dep100_m, pH, Sal_ppt, LDO_mg_l)#pair down dataset to what we need

#Check the data structure
#Note: Date = format Date and TS = format POSIXct (time series). Everything else should be numbers.

str(wq)


#3. Make individual plots ####

#Set data limits - This will help cut the time series to the dates we want to look at.
limits = as.POSIXct(c("2021-01-01 00:00:00", "2021-03-01 00:00:00"))


#* Water Depth Plot ####

depth.plot <- ggplot(wq, aes(x = TS, y = Dep100_m)) +
  geom_line() +
  scale_x_datetime(name = "",
                   date_breaks = "1 week", date_labels = ("%b %d"),
                   limits = limits, expand = c(0,0)) +
  scale_y_continuous(name = "Height [m]", limits = c(1.5, 3.5)) +
  theme_classic()


#* Turbidity Plot ####

turb.plot <- ggplot(wq, aes(x = TS, y = TurbSC_NTU)) +
  geom_line() +
  scale_x_datetime(name = "",
                   date_breaks = "1 week", date_labels = ("%b %d"),
                   limits = limits, expand = c(0,0)) +
  scale_y_continuous(name = "Turbidity [NTU]", limits = c(0, 3000)) +
  theme_classic()

#* pH Plot ####

pH.plot <- ggplot(wq, aes(x = TS, y = pH)) +
  geom_line() +
  scale_x_datetime(name = "",
                   date_breaks = "1 week", date_labels = ("%b %d"),
                   limits = limits, expand = c(0,0)) +
  scale_y_continuous(name = "pH", limits = c(7, 8)) +
  theme_classic()

#* DO Plot ####

do.plot <- ggplot(wq, aes(x = TS, y = LDO_mg_l)) +
  geom_line() +
  scale_x_datetime(name = "",
                   date_breaks = "1 week", date_labels = ("%b %d"),
                   limits = limits, expand = c(0,0)) +
  scale_y_continuous(name = "DO [mg/L]", limits = c(8.5, 12.1)) +
  theme_classic()

#* Temperature Plot ####

temp.plot <- ggplot(wq, aes(x = TS, y = Temp_C)) +
  geom_line() +
  scale_x_datetime(name = "",
                   date_breaks = "1 week", date_labels = ("%b %d"),
                   limits = limits, expand = c(0,0)) +
  scale_y_continuous(name = "Temperature [*C]", limits = c(6.5, 25.5)) +
  theme_classic()

#* Salinity Plot ####
# NOTE: not much to see since its freshwater the whole time.

# sal.plot <- ggplot(wq, aes(x = TS, y = Sal_ppt)) +
#   geom_line() +
#   scale_x_datetime(name = "",
#                    date_breaks = "1 week", date_labels = ("%b %d"),
#                    limits = limits, expand = c(0,0)) +
#   scale_y_continuous(name = "Salinity [ppt]", limits = c(8.5, 12.1)) +
# theme_classic()


#4. Milti-plot output####

#Using the "Patchwork" package to pull individual plots together into one multi-plot
#Note te notation below only works with patchwork. 

# depth.plot / turb.plot / pH.plot / do.plot / temp.plot

depth.plot / turb.plot 

#Save the output
#Note: its a good practice to keep the ggsave function "commented out" so you do not override preivious files.

# ggsave("Figures/WQ_20210413_6x4.jpg", width = 6, height = 4, units = "in", dpi = 650, device = "jpg")


#4. pH exploration####

ph.dat <- read.csv("Data/pH_20210413.csv", sep = ",", header = T) #pH dataset only


ph <- ph.dat %>% #Start formatting columns into r "tidy" structure.
  mutate(Date = mdy(Date)) %>% #R sees dates as Year-Month-Day this tells it where to get that info from the date column.
  mutate(Time = hms(Time)) %>% # Tells r this column is Hours:Min:Sec
  mutate(TS = as.POSIXct(Date + Time)) %>%  #making a new column with timestamp by combining Date and Time
  select(Date, TS, pH)

str(ph)

#Calculate the daily pH statistics using the eXtensible Time Series package
library(xts) # package helps with time-based data classes.

ph.xts <- as.xts(ph[,3], order.by = as.Date(ph[,2], format = '%Y-%m-%d %H:%M')) #creates an xts object

# Daily Stats
d.mean <- apply.daily(ph.xts, mean) # Daily mean
d.mean.out <- mean(apply.daily(ph.xts, mean)) 
d.min <- apply.daily(ph.xts, min) # Daily min
d.min.out <- min(apply.daily(ph.xts, min))
d.max <- apply.daily(ph.xts, max) # Daily max
d.max.out <- max(apply.daily(ph.xts, max))

ph.summary <- bind_cols(
                        fortify(d.mean), #Note:Fortify is from the ggplot 2 package and makes the xts object into a df
                        fortify(d.max),
                        fortify(d.min)) %>%
             mutate(Date = Index...1) %>% 
             select(-Index...1, -Index...3, -Index...5)

str(ph.summary)


pH.daily.plot <- ggplot(ph.summary, aes(x = Date, y = d.mean)) +
  geom_line() +
  scale_x_datetime(name = "",
                   date_breaks = "1 week", date_labels = ("%b %d"),
                   limits = limits, expand = c(0,0)) +
  scale_y_continuous(name = "pH", limits = c(7.2, 8)) +
  theme_classic()

depth.plot / turb.plot / pH.daily.plot

# ggsave("Figures/WQ_20210413_B_6x6.jpg", width = 6, height = 6, units = "in", dpi = 650, device = "jpg")
