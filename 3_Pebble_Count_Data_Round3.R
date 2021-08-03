###############################################
##
## Script name: 3_Pebble_Count_Data_Round3.R
##
## Goals: 1. Visualize the sediment distributions at each site/transect. 
##           (Data needs to be manipulated from size class counts (summaries) 
##           to individual pebbles).
##
##        2. Estimate the change in the amount of surface fines at each transect
##           (reported as % change over time). Note: The cuttoff for "fines" in 
##           the litterature is a bit ambiguous. For now we will stick with 
##           "fines" meaning <6mm (though <8mm could also been used).
##
##        3. Compare how different surface summary statistics (i.e. Dx) changed 
##           after the “first flush” at 1.A each site and 1.B longitudinally 
##           along the mainstem and Big Creek.
##
## Note: See https://github.com/RMBond/ScottCreek-WY21_CZUFire_Poster for project information.
##
###############################################

#Load packages
library(tidyverse)
library(dplyr)
library(lubridate)
# library(ggplot2)
library(patchwork)

#1. Read in the data ####

#Input file contains 3 rounds of data (round 3 is after all precipitation had stopped whareas round 2 was in the middle of the Winter a.k.a. first flush).
pc.dat <- read.csv("Data/Scott_Creek_Pebble_20210802.csv", sep = ",", header = T) #1104 obs of 7 var. 

#2. Do some data wrangling ####

pc <- pc.dat %>% #Start formatting columns into r "tidy" structure.
  mutate(Date = mdy(Date)) %>% 
  mutate(Round = as.factor(Round)) %>% #change column to type = factor
  mutate(Long_Station = as.numeric(Long_Station)) %>% #change column to type = numeric.
  mutate(Category_total = as.numeric(Category_total)) %>% #change column to type = numeric.
  # mutate(Transect = replace_na(Transect, 0)) %>% #replace na (for PCX transects) with a zero 
  group_by(Round, Site, Transect) %>% #Tells r to group each individual transect worth of data to calculate % finer.
  arrange(Size_class_mm) %>% #makes sure data goes from smallest to larges pebble sizes.
  mutate(Percent_finer = cumsum(Category_total)/sum(Category_total)) #create column for percent finer than. 

#Check the data structure

str(pc)

#3. Cumulative percent finer plots for the eFishing sites ####
#Goal: Quickly visualize some of the transect changes between survey rounds.
#      (Not intended for the poster). 

test.bc <- pc %>% 
  filter(Long_Station == 9)

#Big Creek Plot - Subtle changes in sediment.
bc <- ggplot(test.bc, aes(Size_class_mm, Percent_finer, color = Round)) +
  geom_line() +
  facet_grid(Transect ~ .) +
  scale_x_log10(name = "Partical size [Log10(mm)]") +
  scale_y_continuous(name = "Cumulative percent finer", limits = c(0,1), expand = c(0,.1)) +
  # scale_color_manual(values = c("#a6611a", "#018571")) +
  theme_classic() +
  ggtitle("Big Creek")

test.um <- pc %>% 
  filter(Long_Station == 6)

#Upper Mainstem Plot - Fines have increased substantially in the upper watershed. 
um <- ggplot(test.um, aes(Size_class_mm, Percent_finer, color = Round)) +
  geom_line() +
  facet_grid(Transect ~ .) +
  scale_x_log10(name = "Partical size [Log10(mm)]") +
  scale_y_continuous(name = "", limits = c(0,1), expand = c(0,.1)) +
  # scale_color_manual(values = c("#a6611a", "#018571")) +
  theme_classic() +
  ggtitle("Upper Mainstem")

#Little Creek Plot
test.lc <- pc %>% 
  filter(Long_Station == 11)

lc <- ggplot(test.um, aes(Size_class_mm, Percent_finer, color = Round)) +
  geom_line() +
  facet_grid(Transect ~ .) +
  scale_x_log10(name = "Partical size [Log10(mm)]") +
  scale_y_continuous(name = "", limits = c(0,1), expand = c(0,.1)) +
  # scale_color_manual(values = c("#a6611a", "#018571")) +
  theme_classic() +
  ggtitle("Little Creek")

#Put plots together using patchwork
bc + um + lc +
  plot_layout(guides = 'collect') & 
  theme(legend.position = 'bottom') 
# plot_annotation(caption = 'If the blue line starts above the tan line, it means the surface sediment became finer after the first flush.')

# ggsave("Figures/PC_20210406_5x4.jpg", width = 5, height = 4, units = "in", dpi = 650, device = "jpg")


#4. Percent fines (<6mm) along the mainstem by station number (pc2)####
#Goal: Visualize the amount (percent surface fines along the mainstem. Station number is used to lign up the sites from downstream to upstream.

pc2.mainstem.fines <- pc %>% 
  filter(Size_class_mm == 5.6) %>% #select the fines size class.
  filter(Long_Station < 8) %>% #mainstem stations
  filter(Transect == 0 | Transect == 2) #use T2 (midpoint) for each eFishing reach.

a <- ggplot(pc2.mainstem.fines, aes(x = Long_Station, y = Percent_finer, color = Round)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(name = "Percent surface fines", limits = c(0,1.0), expand = c(0,0)) +
  scale_x_continuous(name = "Station Number", limits = c(1,7), breaks = seq(0,7,1)) +
  scale_color_manual(values = c("#a6611a", "blue","#018571"), labels = c("Before", "Middle","After")) +
  theme_classic() +
  geom_hline(yintercept = 0, lty = 2) +
  labs(title = "A") +
  # subtitle = "Flow is from right (upstream) to left (downstream)") +
  # caption = "The meainstem between Big and Little Creeks (Station 3) and the upper watershed \n (Stations 6 and 7) had the biggest increases in fine sediment.")
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        legend.position = "top",
        legend.title = element_blank())

#5. Caculate change in % fines (<6mm) for each transect (pc2) ####
#Goal: Caculate the change in % fines (<6mm) between the two survey rounds for each transect and site.

#Subset data by Round
pc2.r1 <- pc %>%
  filter(Round == 1) %>% #Round 1 data
  filter(Size_class_mm == 5.6) #focus on the 5.6 size class for each transect

# pc2.r2 <- pc %>%
#   filter(Round == 2) %>% #Round 2 data
#   filter(Size_class_mm == 5.6) #focus on the 5.6 size class for each transect

pc2.r3 <- pc %>%
  filter(Round == 3) %>% #Round 2 data
  filter(Size_class_mm == 5.6) #focus on the 5.6 size class for each transect

#Spread data into long format to calculate % change
pc2 <- full_join(pc2.r1, pc2.r3, by = c("Long_Station", "Transect")) %>% #Joins the two rounds of data
  mutate(fines_per_change = Percent_finer.y - Percent_finer.x) %>% #Subract round 1 from round 2. A positive number means an increase in fines after the first flush.
  mutate(Site = Site.x) %>% #relabeling site for clarity
  select(Site, Transect, Long_Station, fines_per_change)


#select transects 0 or 2

pc2.2 <- pc2 %>% 
  filter(Transect == 0 | Transect == 2)

mean(pc2.2$fines_per_change) #14.5
min(pc2.2$fines_per_change) #-0.07
max(pc2.2$fines_per_change) #0.26

mean(pc2$fines_per_change) #16.3
min(pc2$fines_per_change) #-0.11
max(pc2$fines_per_change) #0.45


#---------------------------------------------------------------------------------------



#Plot % fines change over longitudinal station distance

#Subset data by mainstem vs tributary stations (See above for station number key)
pc2.mainstem <- pc2 %>%
  filter(Long_Station < 8) %>%
  filter(Transect == 0 | Transect == 2)

pc2.bigcreek <- pc2 %>%
  filter(Long_Station > 7 & Long_Station < 11) %>%
  filter(Transect == 0 | Transect == 2)

pc2.littlecreek <- pc2 %>%
  filter(Long_Station == 11) %>%
  filter(Transect == 0 | Transect == 2)

#Subset efishing reaches to make ranges for plot
stattest <- pc2 %>%
  filter(Long_Station == 7)

#Mainstem plot

b <- ggplot(pc2.mainstem, aes(x = Long_Station, y = fines_per_change)) +
  geom_line() +
  geom_point() +
  scale_y_continuous(name = "Change in percent fines", limits = c(-0.2,0.45), breaks = seq(-0.2,0.45,.1), expand = c(0,0)) +
  scale_x_continuous(name = "Station Number", limits = c(1,7), breaks = seq(0,7,1)) +
  theme_classic() +
  geom_hline(yintercept = 0, lty = 2) +
  # geom_segment(x = 1, y = -0.13, xend = 1, yend = 0.08, lty = 3) + #variation in Station 1
  # geom_segment(x = 6, y = 0.12, xend = 6, yend = 0.25, lty = 3) + #variation in Station 6
  # geom_segment(x = 7, y = -0.11, xend = 7, yend = 0.3857, lty = 3) + #variation in Station 7
  labs(title = "B")
# labs(title = "Change in percent fines (<6mm) along the mainstem",
#      subtitle = "Flow is from right (Upstream) to left (Downstream)",
#      caption = "The meainstem between Big and Little Creeks (Station 3) and the upper watershed \n (Stations 6 and 7) had the biggest increases in fine sediment. \n Dotted vertical lines are ranges at the eFishing sites.")

#Putting plots together
a / b

# ggsave("Figures/PC_percent_fines_mainstem_20210406_6x6.jpg", width = 6, height = 6, units = "in", dpi = 650, device = "jpg")


#6. Boxplot of percent surface fines (pc3) ####
#Goal: Boxplot of percent surface fines using all sites/transects

pc3.fines <- pc %>% 
  filter(Size_class_mm == 5.6)

plot.pc3.fines.all <- ggplot(pc3.fines, aes(x = Round, y = Percent_finer)) +
  geom_boxplot() +
  scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                     expand = c(0,0))  +
  ggtitle("All sites")

#Boxplot of percent surface fines on mainstem
pc3.fines.mainstem <- pc %>% 
  filter(Size_class_mm == 5.6) %>% 
  filter(Long_Station < 8)

plot.pc3.fines.mainstem <- ggplot(pc3.fines.mainstem, aes(x = Round, y = Percent_finer)) +
  geom_boxplot(fill = c("#011a27", "blue", "#e6df44")) +
  scale_x_discrete(name = "", limits = c("1","2","3"), labels = c("Before", "Mid", "After")) +
  scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                     expand = c(0,0)) +
  theme_classic() +
  # theme(axis.text.x = element_blank(), #use for portrait layout
  #       axis.title.y = element_blank()) +
  # ggtitle("Scott Creek Mainstem (n=13)")
  ggtitle("Scott Creek Mainstem")

#Boxplot of percent surface fines on Big Creek
pc3.fines.bc <- pc %>% 
  filter(Size_class_mm == 5.6) %>% 
  filter(Long_Station > 7 & Long_Station < 11)

plot.pc3.fines.bc <- ggplot(pc3.fines.bc, aes(x = Round, y = Percent_finer)) +
  geom_boxplot(fill = c("#011a27", "blue", "#e6df44")) +
  scale_x_discrete(name = "", limits = c("1","2","3"), labels = c("Before", "Mid", "After")) +
  scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                     expand = c(0,0)) +
  theme_classic() +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank()) +
  ggtitle("Big Creek")
# ggtitle("Big Creek (n=7)")


#Boxplot of percent surface fines on Little Creek
pc3.fines.lc <- pc %>% 
  filter(Size_class_mm == 5.6) %>% 
  filter(Long_Station == 11)

plot.pc3.fines.lc <- ggplot(pc3.fines.lc, aes(x = Round, y = Percent_finer)) +
  geom_boxplot(fill = c("#011a27", "blue", "#e6df44")) +
  scale_x_discrete(name = "", limits = c("1","2","3"), labels = c("Before", "Mid", "After")) +
  scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                     expand = c(0,0)) +
  theme_classic() +
  theme(axis.text.y = element_blank(),
        axis.title.y = element_blank()) +
  # ggtitle("Little Creek (n=3)")
  ggtitle("Little Creek")

#Put plots together using patchwork
plot.pc3.fines.mainstem +  plot.pc3.fines.bc +  plot.pc3.fines.lc # Landscape layout

# ggsave("Figures/PC_percent_fines_boxplot_20210414_7x3.jpg", width = 7, height = 3, units = "in", dpi = 650, device = "jpg")


plot.pc3.fines.mainstem /  plot.pc3.fines.bc /  plot.pc3.fines.lc # Portrait layout

# ggsave("Figures/PC_percent_fines_boxplot_20210413_3x6.jpg", width = 3, height = 6, units = "in", dpi = 650, device = "jpg")


#Variation in Percent Fines for each eFishing Site starting with pc3.fines

#Grab the eFishing sites
pc3.efishing <- pc3.fines %>% 
  filter(grepl('eFishing', Site)) #using grepl to select all sites with "efishing" in the name 

#Tell r Sites will be in a specific order.
pc3.efishing$Site <- factor(pc3.efishing$Site, levels = c("Dog eFishing","Upper Mainstem eFishing","Lower Mainstem eFishing","Big Creek Powerhouse eFishing","Big Creek eFishing", "Little Creek eFishing"),ordered = TRUE)

#Scatterplot to see the variation (3 transects) in percent fines for each eFishing Site.
ggplot(pc3.efishing, aes(x = Site, y = Percent_finer, color = Round)) +
  geom_jitter(width = 0.1) +
  scale_y_continuous(name = "Percent surface fines (<6mm)", limits = c(0,1),
                     expand = c(0,0)) +
  scale_color_manual(values = c("#a6611a", "blue","#018571"), labels = c("Before", "Mid","After")) +
  theme_classic() +
  theme(legend.position = "top",
        legend.title = element_blank())


#STATS - TBD
#Need to figure out if we are using t-tests or Chi-squared test for independance?
#Before running the t tests we need to think about independance (repeated measures??. 

#Mainstem
pc3.fines.mainstem.r1 <-  pc3.fines.mainstem %>% 
  filter(Round == 1) %>% #Round 1 data  
  select(Percent_finer)

pc3.fines.mainstem.r2 <-  pc3.fines.mainstem %>% 
  filter(Round == 2) %>% #Round 2 data
  select(Percent_finer)

# t.test( pc3.fines.mainstem.r1$Percent_finer,  pc3.fines.mainstem.r2$Percent_finer, alternative = "two.sided") #May need to adjust the alternative to "greater than".

# Big Creek
pc3.fines.bc.r1 <-  pc3.fines.bc %>% 
  filter(Round == 1) %>% #Round 1 data  
  select(Percent_finer)

pc3.fines.bc.r2 <-  pc3.fines.bc %>% 
  filter(Round == 2) %>% #Round 2 data
  select(Percent_finer)

# t.test( pc3.fines.bc.r1$Percent_finer,  pc3.fines.bc.r2$Percent_finer, alternative = "two.sided") #May need to adjust the alternative to "greater than".

#Little Creek
pc3.fines.lc.r1 <-  pc3.fines.lc %>% 
  filter(Round == 1) %>% #Round 1 data  
  select(Percent_finer)

pc3.fines.lc.r2 <-  pc3.fines.lc %>% 
  filter(Round == 2) %>% #Round 2 data
  select(Percent_finer)

# t.test( pc3.fines.lc.r1$Percent_finer,  pc3.fines.lc.r2$Percent_finer, alternative = "two.sided") #May need to adjust the alternative to "greater than".


#7. Sediment Distribution Plots ####

#* 7.1 Expand count summaries to individual counts (pc4) ####
#The tidy package has the function "uncount" which is the opposite operation of "dplyr::count"

pc4 <- pc %>% 
  group_by(Long_Station, Transect, Round)

pc4.pebbles <- uncount(pc4, Category_total, .id = "id") %>% 
  mutate(Pebble_mm = Size_class_mm) %>% #rename column to emphasize we are looking at individual pebbles now
  select(!Size_class_mm) #remove column

#* 7.2 Calculate D50 for plotting (pc4) ####
#Goal: Calculate the median (by definition the D50) for each site, transect, and round

pc4.d50 <- pc4.pebbles %>% 
  summarise(d50 = median(Pebble_mm))

ggplot(pc4.d50, aes( x = Long_Station, y = d50, color = Round, shape = factor(Transect))) + 
  geom_jitter(width = 0.1)

#Looking at only eFishing Sites
#Grab the eFishing sites
pc4.efishing <- pc4.pebbles %>% 
  filter(grepl('eFishing', Site)) #using grepl to select all sites with "efishing" in the name 

#Tell r Sites will be in a specific order.
pc4.efishing$Site <- factor(pc4.efishing$Site, levels = c("Dog eFishing","Upper Mainstem eFishing","Lower Mainstem eFishing","Big Creek Powerhouse eFishing","Big Creek eFishing", "Little Creek eFishing"),ordered = TRUE)

pc4.d50.efish <- pc4.efishing %>% 
  summarise(d50 = median(Pebble_mm))

ggplot(pc4.d50.efish, aes( x = Site, y = d50, color = Round, shape = factor(Transect))) + 
  geom_jitter(width = 0.1)

#Looking longitudinally along the mainstem
pc4.d50.mainstem <- pc4.pebbles %>% 
  filter(Long_Station < 8) %>%  #mainstem stations
  summarise(d50 = median(Pebble_mm))

pc4.d50.mainstem$Site <- factor(pc4.d50.mainstem$Site, levels = c("Lower Mainstem eFishing", "PCX-1", "PCX-2", "PCX-4", "PCX-5", "Upper Mainstem eFishing", "Dog eFishing"),ordered = TRUE)

ggplot(pc4.d50.mainstem, aes( x = Long_Station, y = d50, color = Round, shape = factor(Transect))) +
  geom_jitter(width = 0.1) +
  scale_y_continuous(name = "D50", limits = c(0,64),
                     expand = c(0,0)) +
  # scale_color_manual(values = c("#a6611a", "#018571"), labels = c("Before", "After")) +
  theme_classic() +
  theme(legend.position = "bottom")

# ggsave("Figures/PC_d50_mainstem_20210406_9x3.jpg", width = 9, height = 3, units = "in", dpi = 650, device = "jpg")

#* 7.3 Pebble distribution plots (pc4) ####
#Quick scatterplot to see the data points
ggplot(pc4.pebbles, aes( x = Long_Station, y = Pebble_mm, color = Round, shape = factor(Transect))) + 
  geom_jitter()


#Violin plot - hard to see
ggplot(pc4.pebbles, aes( x = Long_Station, y = Pebble_mm, color = Round)) +
  geom_violin()

#Box plot 
ggplot(pc4.pebbles, aes( x = Long_Station, y = Pebble_mm, color = Round)) +
  geom_boxplot()
