####Extra pebble count code####
#Purpose: Some of the code is breaking the markdown file so it is being stored here.
#This will need to be run after the main .rmd file is run.

#Repeat above code with 8mm cutoff

#Subset data by Round
pc3.r1.8 <- pc %>%
  filter(Round == 1) %>% #Round 1 data
  filter(Size_class_mm == 8) #focus on the 8 size class for each transect


pc3.r2.8 <- pc %>%
  filter(Round == 2) %>% #Round 2 data
  filter(Size_class_mm == 8) #focus on the 8 size class for each transect

#Spread data into long format to calculate % change
pc3.8 <- full_join(pc3.r1.8, pc3.r2.8, by = c("Site", "Transect")) %>% #Joins the two rounds of data
  mutate(fines_per_change = Percent_finer.y - Percent_finer.x) %>% #Subract round 1 from round 2. A positive number means an increase in fines after the first flush.
  mutate(Long_Station = Long_Station.x) %>% #relabeling station for clarity
  select(Site, Transect, Long_Station, fines_per_change)

#Plot % fines change over longitudinal station distance

#Subset data by mainstem vs tributary
pc3.8.mainstem <- pc3.8 %>%
  filter(Long_Station < 8) %>%
  filter(Transect == 0 | Transect == 2)

pc3.8.bigcreek <- pc3.8 %>%
  filter(Long_Station > 7 & Long_Station < 11) %>%
  filter(Transect == 0 | Transect == 2)

pc3.8.littlecreek <- pc3.8 %>%
  filter(Long_Station == 11) %>%
  filter(Transect == 0 | Transect == 2)

#Subset efishing reaches to make ranges for plot
lmef <- pc3.8 %>%
  filter(Long_Station == 7)

#Mainstem plot

ggplot(pc3.8.mainstem, aes(x = Long_Station, y = fines_per_change)) +
  geom_line() +
  scale_y_continuous(name = "Percent Change (<8mm)", limits = c(-0.2,0.45), breaks = seq(-0.2,0.45,.1), expand = c(0,0)) +
  scale_x_continuous(name = "Longitudinal Distance", limits = c(1,7), breaks = seq(0,7,1)) +
  theme_classic() +
  geom_hline(yintercept = 0, lty = 2) +
  geom_segment(x = 1, y = -0.12, xend = 1, yend = 0.09, lty = 3) + #variation in Station 1
  geom_segment(x = 6, y = 0.11, xend = 6, yend = 0.29, lty = 3) + #variation in Station 6
  geom_segment(x = 7, y = -0.1, xend = 7, yend = 0.43, lty = 3) + #variation in Station 7
  labs(title = "Change in percent fines (<8mm) along the mainstem",
       subtitle = "Flow is from right (Upstream) to left (Downstream)",
       caption = "The meainstem between Big and Little Creeks (Station 3) and the upper watershed \n (Stations 6 and 7) had the biggest increases in fine sediment. Dotted vertical lines are ranges at the eFishing sites.")


#Dx calculation experimental code:
pc.test$Percent_finer) = -Inf,"small", 1),

