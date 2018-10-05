library(tidyverse)
library(ICPIutilities)

got <- ICPIutilities::read_msd("ex2_data.txt")

## Review:
nrow(got)


## Review: summarise and pipe

got %>%
  group_by(psnu, implementingmechanismname, indicator) %>%
  summarise(num=n()) %>%
  arrange(-num)

got %>%
  group_by(psnu, implementingmechanismname, indicator, disaggregate, categoryoptioncomboname, ismcad) %>%
  summarise(num=n()) %>%
  arrange(-num)

## Review: filter, select

got_subset <- got %>%
  filter(standardizeddisaggregate == "Total Numerator" & 
         indicator %in% c("TX_CURR","TX_NEW","HTS_TST_POS") &
         ismcad=="N") 

## Transposing from wide to long: gather

got_txlong <- tidyr::gather(got_subset, period, value, starts_with("fy20")) %>% 
  # Remove NA values that resulted from the transpose
  # these are typically indicators or sites that did not report during that period:
  dplyr::filter(!is.na(value)) %>%
  group_by(psnu, implementingmechanismname, indicator, disaggregate, categoryoptioncomboname, period) %>%
  # this next step is very helpful for eliminating unnoticed duplicate lines even if data values blank
  # about to lose TA vs. DSD or instances when prioritization switched
  dplyr::summarise(value=sum(value, na.rm=TRUE))

  # options for reshape from long to wide to prepare calculations
got_calcwide <- tidyr::spread(got_txlong, indicator, value)

  # a similar transposing command reshape2 gives you more control to specify which variables go into columns
  # got_calcwide <- reshape2::dcast(got_txlong, ... ~ indicator, value.var="value",na.rm=TRUE)

## Using Mutate to calculate indicators

got_calcwide <- mutate(got_calcwide, linkage=TX_NEW/HTS_TST_POS)

## more to come...not finished

  
  
