getwd()

library(tidyverse)
library(stringr)
library(ggplot2)

#1 Read file
storm_data <- read.csv("~/Downloads/McDaniel/StormEvents_details-ftp_v1.0_d1995_c20220425.csv")

#2 Limit dataset
myvars <- c("BEGIN_YEARMONTH", "EPISODE_ID", "STATE", "STATE_FIPS", "CZ_NAME", "CZ_TYPE", "CZ_FIPS", "EVENT_TYPE")
storm_limited <- storm_data[myvars]

#3 Arrange dataset
storm_arranged <- arrange(storm_limited, STATE)

#4 Change Names
str_to_lower(storm_arranged$STATE)
str_to_lower(storm_arranged$CZ_NAME)

str_to_title(storm_arranged$STATE)
str_to_title(storm_arranged$CZ_NAME)

print(storm_arranged)

#5 Limit and remove
storm_filtered <- filter(storm_arranged, CZ_TYPE=="C")
storm_select <- select(storm_filtered, -'CZ_TYPE')

#6 Pad state and county
str_pad(storm_select$STATE_FIPS, width=3, side="left", pad="0")
storm_united <- unite(storm_select, FIPS, 'STATE_FIPS', 'CZ_FIPS', sep = "_", remove = FALSE)

#7 Rename columns
storm_renamed <- rename_all(storm_united, tolower)

#8 New dataset
data("state")
us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)

#9 Merge datasets
state_freq <- data.frame(table(storm_renamed$state))
head(state_freq)

state_freq1 <- rename(state_freq, c("state"="Var1"))
us_state_info_1 <- (mutate_all(us_state_info, toupper))
mutate_all(state_freq1, toupper)

merged <- merge(x=state_freq1,y=us_state_info_1,by.x="state", by.y="state")

#10 
storm_plot <- ggplot(merged, aes(x = area, y = Freq)) + 
  geom_point(aes(color=region)) +
  labs(x="Land area (square miles)",
       y="# of storm events in 1995")
storm_plot




