# require("tidyverse")
# reqiure("devtools")
# devtools::install_github("ICPI/ICPIutilities")

library(tidyverse)
library(ICPIutilities)
library(reshape2)

got <- ICPIutilities::read_msd("ex2_data.txt")

### Review: basic dataset descriptors 

# number of rows; count observations by category
nrow(got)
dplyr::count(got,psnu)
# STRucture of dataset; first 10 rows of dataset; tabulate variable
str(got)
head(got,10)
table(got$psnu)

### Review: summarise and pipe

got %>%
  group_by(psnu, implementingmechanismname, indicator) %>%
  summarise()

got %>%
  group_by(psnu, implementingmechanismname, indicator) %>%
  summarise(num=n()) %>%
  arrange(-num)

got %>%
  group_by(psnu, implementingmechanismname, standardizeddisaggregate) %>%
  summarise(num=n()) %>%
  arrange(-num)


## Review: filter, select

got_subset <- got %>%
  filter(standardizeddisaggregate == "Total Numerator" & 
         indicator %in% c("TX_CURR","TX_NEW","HTS_TST_POS") &
         ismcad=="N") 

got_subset %>%
  group_by(psnu, implementingmechanismname, indicator) %>%
  summarise_at(vars(ends_with("targets")),funs(sum), na.rm=TRUE) 
  
got_subset %>%
  select(psnu,implementingmechanismname,indicator,starts_with("fy20")) %>%
  group_by(psnu, implementingmechanismname, indicator) %>%
  summarise_all(funs(sum), na.rm=TRUE) %>%
  ungroup()
  


## Transposing from wide to long - tidyr::gather and tidyr::spread

got_txlong <- tidyr::gather(got_subset, period, value, starts_with("fy20")) 

count(got_txlong)

# Optional
got_txlong <- got_txlong %>% 
  # Remove NA values that resulted from the transpose
  # these are typically indicators or sites that did not report during that period:
  dplyr::filter(!is.na(value)) %>%
  group_by(psnu, implementingmechanismname, indicator, disaggregate, period) %>%
  # this next step is very helpful for eliminating unnoticed duplicate lines even if data values blank
  # about to lose TA vs. DSD or instances when prioritization switched
  dplyr::summarise(value=sum(value, na.rm=TRUE))

  # options for reshape from long to wide to prepare calculations
got_calcwide <- tidyr::spread(got_txlong, indicator, value)

  # a similar transposing command reshape2 gives you more control to specify which variables go into columns
  # got_calcwide <- reshape2::dcast(got_txlong, ... ~ indicator, value.var="value",na.rm=TRUE)

## Using Mutate to calculate indicators

got_calcwide <- mutate(got_calcwide, linkage=TX_NEW/HTS_TST_POS) 

got_calcwide %>%
  group_by(period) %>%
  summarise(max(linkage,na.rm=TRUE),mean(linkage,na.rm=TRUE))


## Merging datasets together with MSD and IMPATT as example

# read in the external dataset - for example, implementation attributes at the PSNU level
got_IMPATT <- read.delim("~/ICPI/R training/R training session 3 - 2018/got_IMPATT.txt")

# First check number of observations, and/or the variable(s) you will join on, comparing the two datasets.  
# If different number, investigate why, and identify the potential duplication causes

nrow(got_calcwide)
unique(got_calcwide$psnu)

unique(got_IMPATT$psnu)

## use left_join to merge the two datasets based on the psnu variable.

got_merge <- left_join(got_calcwide,got_IMPATT,by="psnu")

## anti_join can show which records did not successfully find matches between the two datasets based
## on the "by" criteria

anti_join(got_calcwide,got_IMPATT,by="psnu")
anti_join(got_IMPATT,got_calcwide,by="psnu")
