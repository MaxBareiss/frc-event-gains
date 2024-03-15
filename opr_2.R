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
require('viridis')

# Clear stored data
rm(list = ls(all = TRUE))

#Set working directory to source file location
this.dir <- file.path(dirname(parent.frame(2)$ofile))
setwd(this.dir)

ave_scores = read_csv("opr_1_download.csv")

dates = read_csv("tidy_3_dates.csv")

ave_scores %<>% inner_join(dates) %>% 
                select(-year_event) %>% 
                mutate(year = as.integer(year(date)), week = week(date)-6) %>%
                filter(week <= 7)
# print(ave_scores)
# print(summary(ave_scores))

year_count = ave_scores %>%
             group_by(year, team_number) %>%
             summarize(count = n()) %>%
             filter(count >= 2)

ave_scores %<>% inner_join(year_count)
print(ave_scores)
print(summary(ave_scores))

# stop()

perf_bump = ave_scores %>%
            arrange(date) %>%
            group_by(year, team_number) %>%
            summarize(first_score = opr[1],
                      second_score = opr[2],
                      time_delta = week[2] - week[1],
                      bump = (opr[2] / opr[1]) - 1) %>%
            filter(time_delta != 0) %>% ungroup()

print(summary(perf_bump))

perf_bump %<>% filter(year > 2009)

ranges = perf_bump %>% group_by(year) %>% summarize(iqr=IQR(bump),median=median(first_score))

# perf_bump %<>% left_join(ranges) %>% mutate(bump = bump / median)

print(summary(perf_bump))

perf_bump_plot = ggplot(perf_bump) +
                 stat_ecdf(aes(x=bump,color=as.factor(year))) +
                 scale_x_continuous("OPR Gain, Event 1 -> Event 2", labels=scales::percent) +
                 scale_y_continuous("Cumulative Distribution", labels=scales::percent) +
                 ggtitle(sprintf("%s team-seasons",prettyNum(nrow(perf_bump),big.mark=','))) +
                 coord_cartesian(xlim=c(-1.25,1.25)) +
                 scale_color_viridis("Year",discrete=T) +
                 theme_bw() +
                 theme(legend.position='right')

ggsave("opr_2_perf_bump_plot.png",perf_bump_plot,width=5.5,height=4,units='in',dpi=300)

evt_scores_plot = ggplot(perf_bump) +
                  stat_ecdf(aes(x=first_score),color='red') +
                  stat_ecdf(aes(x=second_score),color='blue') +
                  theme_bw() +
                  scale_x_continuous("OPR") +
                  scale_y_continuous("Cumulative Distribution", labels=scales::percent) +
                  scale_color_discrete("Week")

ggsave("opr_2_evt_scores_plot.png",evt_scores_plot,width=5.5,height=4,units='in',dpi=300)

pts_year_plot = ggplot(perf_bump) +
                  stat_ecdf(aes(x=first_score,color=as.factor(year))) +
                  theme_bw() +
                  scale_x_continuous("OPR") +
                  scale_y_continuous("Cumulative Distribution", labels=scales::percent) +
                  scale_color_discrete("Year")

ggsave("opr_2_pts_year_plot.png",pts_year_plot,width=5.5,height=4,units='in',dpi=300)
