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

# Clear stored data
rm(list = ls(all = TRUE))

#Set working directory to source file location
this.dir <- file.path(dirname(parent.frame(2)$ofile))
setwd(this.dir)

data = Sys.glob("the-blue-alliance-data/events/*/*/*_matches.csv") %>% map_df(~read_csv(.,
        col_names=c('key', 'red1', 'red2', 'red3', 'blue1', 'blue2', 'blue3', 'red_score', 'blue_score'),
        col_types=c('cccccccdd')))

write_csv(data,"tidy_1_data.csv")
