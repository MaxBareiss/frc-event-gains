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
