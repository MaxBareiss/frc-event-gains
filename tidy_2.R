# Copyright (C) 2024 Max Bareiss

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
require('tidyverse')
require('magrittr')
require('stringr')

# Clear stored data
rm(list = ls(all = TRUE))

#Set working directory to source file location
this.dir <- file.path(dirname(parent.frame(2)$ofile))
setwd(this.dir)

data = read_csv("tidy_1_data.csv")

red_data = data %>% mutate(year_event = str_split_i(key,"_",1)) %>% 
           pivot_longer(red1:red3,names_to="position",values_to="team_number") %>%
           select(year_event,score=red_score,team_number)

blue_data = data %>% mutate(year_event = str_split_i(key,"_",1)) %>% 
           pivot_longer(blue1:blue3,names_to="position",values_to="team_number") %>%
           select(year_event,score=blue_score,team_number)

data = bind_rows(red_data,blue_data)

ave_scores = data %>% group_by(year_event,team_number) %>% summarize(ave=mean(score,na.rm=T)) %>% filter(!is.na(ave))

write_csv(ave_scores,"tidy_2_ave_scores.csv")

events = data %>% select(year_event) %>% distinct()
write_csv(events,"tidy_2_events.csv",col_names=F)
