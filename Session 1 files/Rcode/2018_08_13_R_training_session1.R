
#___________________________________________________________________________
#~~~~~~~~~~~      _____   _             _       _                ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |  __ \ | |           (_)     (_)               ~~~~~~~~~~~~~~~ 
#~~~~~~~~~~~     | |__) || |_ _ __ __ _ _ _ __  _ _ __   __ _    ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |  _  / | __| '__/ _` | | '_ \| | '_ \ / _` |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     | | \ \ | |_| | | (_| | | | | | | | | | (_| |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~     |_|  \_\ \__|_|  \__,_|_|_| |_|_|_| |_|\__, |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~           ______                            __/ |   ~~~~~~~~~~~~~~~
#~~~~~~~~~~~          |______|                           \___/   ~~~~~~~~~~~~~~~
#___________________________________________________________________________


#-------------------------------------------------------
# ---- (0) Loading Tidyverse Package (Slide )----- 
#--------------------------------------------------------
install.packages("tidyverse")
library(tidyverse)

#---------------------------------------------------------





#-------------------------------------------------------
# ---- (1) Importing TXT datafile using readr(Slide )----- 
#--------------------------------------------------------
# function used is 'read_tsv' & its arguments (file path and/or name), 
# reads in txt file named "ex1_data.txt", and stores dataset as an object named 'txt' 
# object <- function(relative file path/filename.txt)


# Importing .txt file using 'readr' package
# install.packages("readr")
# library(readr)

# Full path to data file
txt <- read_tsv("C:/Users/lqa9/Desktop/R/ICPI R training/Reboot/R_training_reduxV2/RawData/ex1_data.txt", col_names = TRUE)


# Relative folder paths
# Subfolder in project - dependent on setting the working directory properly  
txt <- read_tsv("./RawData/ex1_data.txt", col_names = TRUE)

# To see the types of the variables in the dataset, use spec()
spec(txt)


# Specifying the type of each variable being pulled in
#             "c" = character 
#             "i" = integer 
#             "n" = number 
#             "d" = double (includes decimals)
#             "l" = logical 
#             "D" = date 
#             "T" = date time 
#             "t" = time 
#             "?" = guess


# Add customized variable types for accuracy
txt2 <- read_tsv(file = "./RawData/ex1_data.txt", 
                    col_types = cols(MechanismID        = "c",
                                     AgeAsEntered       = "c",            
                                     AgeFine            = "c",     
                                     AgeSemiFine        = "c",    
                                     AgeCoarse          = "c",      
                                     Sex                = "c",     
                                     resultStatus       = "c",     
                                     otherDisaggregate  = "c",     
                                     coarseDisaggregate = "c",     
                                     FY2017_TARGETS     = "d",
                                     FY2017Q1           = "d",      
                                     FY2017Q2           = "d",      
                                     FY2017Q3           = "d",      
                                     FY2017Q4           = "d",      
                                     FY2017APR          = "d",
                                     FY2018Q1           = "d",
                                     FY2018Q2           = "d",
                                     FY2018_TARGETS     = "d",
                                     FY2019_TARGETS     = "d"))


# Check your data classes for all variables
spec(txt2)

# checking a single variable class
class(txt2$indicator)


#---------------------------------------------------------



#-------------------------------------------------------
# ---- (2) Importing CSV datafile using readr(Slide )----- 
#--------------------------------------------------------
# function used is 'read_csv' & its arguments (file path and/or name), 
# reads in csv file named "ex1_data.csv", and stores dataset as an object named 'csv_df' 
# object <- function(relative file path/filename.csv)


# Importing .txt file using 'readr' package
# install.packages("readr")
# library(readr)

# Full path to data file
csv <- read_csv("C:/Users/lqa9/Desktop/R/ICPI R training/Reboot/R_training_reduxV2/RawData/ex1_data.csv")


# Relative folder paths
csv <- read_csv ("./RawData/ex1_data.csv")
# To see the character types of the variables in the dataset, use spec()
spec(csv)

# Specifying the type of each variable being pulled in
#             "c" = character 
#             "i" = integer 
#             "n" = number 
#             "d" = double (includes decimals)
#             "l" = logical 
#             "D" = date 
#             "T" = date time 
#             "t" = time 
#             "?" = guess


# Add customized variable types for accuracy
csv2 <- read_csv (file = "./RawData/ex1_data.csv", 
                    col_types = cols(MechanismID        = "c",
                                     AgeAsEntered       = "c",            
                                     AgeFine            = "c",     
                                     AgeSemiFine        = "c",    
                                     AgeCoarse          = "c",      
                                     Sex                = "c",     
                                     resultStatus       = "c",     
                                     otherDisaggregate  = "c",     
                                     coarseDisaggregate = "c",     
                                     FY2017_TARGETS     = "d",
                                     FY2017Q1           = "d",      
                                     FY2017Q2           = "d",      
                                     FY2017Q3           = "d",      
                                     FY2017Q4           = "d",      
                                     FY2017APR          = "d",
                                     FY2018Q1           = "d",
                                     FY2018Q2           = "d",
                                     FY2018_TARGETS     = "d",
                                     FY2019_TARGETS     = "d"))
spec(csv2)




# # Pulling dataset from GitHub
MSD <- read_tsv("https://raw.githubusercontent.com/ICPI/TrainingDataset/master/Output/ICPI_MER_Structured_TRAINING_Dataset_PSNU_IM_FY17-18_20180515_v1_1.txt")


# Getting HELP  
?read_csv
help("read_csv")

#---------------------------------------------------------



#-------------------------------------------------------
# ---- (3) Ways to View your dataset(s) (Slide )----- 
#--------------------------------------------------------
View(txt2)  # to see entire dataset
names(txt2) # to see variable names
spec(txt2) 

  # [ ] lets you index your data frame.
  # The first element is for rows and second for columns
  # leaving any element blank selects all (rows or columns) 
View(txt2[1:20, ]) # selects rows 1 to 20 and all columns
View(txt2[1:20, 1:3]) # selects rows 1 to 20 and columns 1 to 3



# The dplyr function, 'select' allows for specifiying any number of variables to retain and view.
select(txt2, OperatingUnit, PSNU, Region)
View (select(txt2, OperatingUnit, PSNU, Region))

# To retain variables that start with or end with a certain string pattern. 
select(txt2, ends_with("Q2"))
select(txt2, starts_with("FY2017"))

# The Dplyr function, 'count' shows a breakdown of a column's unique values. 
count(txt2, OperatingUnit)
count(txt2, Region, OperatingUnit, PSNU, SNU1)
View (count(txt2, Region, OperatingUnit, PSNU, SNU1))

count(txt2, OperatingUnit, SNU1)

# Use group_by with summarise to simulate a pivot table (NEEDS REVIEW)
View (group_by(txt2, OperatingUnit, SNU1) %>%
    summarise(sum(FY2017APR, na.rm = TRUE ))) %>%
    ungroup
  


#-------------------------------------------------------






#-------------------------------------------------------
# ---- (4) Sorting your dataset (Slide )----- 
#--------------------------------------------------------

# Sort variables using 'arrange' function from dplyr

# Sorting in ascending order (default) 
sorted <- arrange (txt2, PSNU)
select(sorted, PSNU)   # Doesn't display all rows
View(select(sorted, PSNU))   # Using 'View" shows all rows
View(count(sorted, PSNU))

# Sorting in descending order
sorted2 <- arrange(txt2, desc(PSNU))
View(select(sorted2, PSNU))
View(count(sorted2, PSNU)) # doesn't obey the sort


# Sorting multiple variables
sorted3 <- arrange(txt2, PSNU, indicator)
View(select(sorted3, PSNU, indicator))
View(count(sorted3, PSNU, indicator))

#-------------------------------------------------------





#-------------------------------------------------------
# ---- (5) Subsetting your data (Slide )----- 
# Ref: https://www.statmethods.net/management/subset.html
#--------------------------------------------------------


#---- Subsetting for Columns (select) -----#

# Use dplyr 'Select' function to subset by variable(s)
geo_df <- select(txt_df, OperatingUnit, SNU1, PSNU, FY2017APR)
names(geo_df)
View(geo_df)

# Alternatively, to delete variables:
geo_df2 <- select(txt_df, -starts_with("FY2017"))
names(geo_df2)
View(geo_df2)

geo_df3 <- select(txt_df, -Region, -CountryName)
names(geo_df3)
View(geo_df3)



#---- Subsetting for Rows (filter) -----#

# filtering for one Indicator
hts <- filter(txt_df, indicator =="HTS_TST")
# Ways to see if this worked
select(hts, indicator)
View (select(hts, indicator))
View (count(hts, indicator))  

# filter for one indicator, (uses logical operator Not Equal) 
hts2 <- filter(txt_df, indicator != "HTS_TST")
View (select (hts2, indicator))
View (count(hts2, indicator)) 


# filter for multiple indicators, (uses logical operator OR) 
hts3 <- filter(txt_df, indicator == "HTS_TST" | indicator == "TX_NEW")
View (select (hts3, indicator))
View (count(hts3, indicator)) 


# filter for multiple conditions, (uses logical operator AND) 
hts4 <- filter(txt2, indicator == "HTS_TST", FY2017APR > 100)
View (select (hts4, indicator, FY2017APR))
View (count(hts4, indicator, FY2017APR)) 


# filter for multiple conditions, (uses multiple operators and multiple conditions) 
# Filtering for HTS_TST and TX_NEW total numerator values and its PSNUs
hts5 <- filter(txt2, indicator == "HTS_TST" | indicator == "TX_NEW", standardizedDisaggregate == "Total Numerator", FY2017APR > 100)
View (select (hts5, PSNU, indicator, standardizedDisaggregate, FY2017APR))
View (count(hts5, PSNU, indicator, standardizedDisaggregate, FY2017APR)) 


#-------------------------------------------------------





#-------------------------------------------------------
# ---- (6) Cleaning your data (Slide )----- 
#--------------------------------------------------------
  # Removing values with 'NA' 
    # reading in the dataset with NA values in Sex
na_df <- read_tsv(file="./RawData/na_data.txt", 
                  col_types = cols(MechanismID        = "c",
                                     AgeAsEntered       = "c",            
                                     AgeFine            = "c",     
                                     AgeSemiFine        = "c",    
                                     AgeCoarse          = "c",      
                                     Sex                = "c",     
                                     resultStatus       = "c",     
                                     otherDisaggregate  = "c",     
                                     coarseDisaggregate = "c",     
                                     FY2017_TARGETS     = "d",
                                     FY2017Q1           = "d",      
                                     FY2017Q2           = "d",      
                                     FY2017Q3           = "d",      
                                     FY2017Q4           = "d",      
                                     FY2017APR          = "d",
                                     FY2018Q1           = "d",
                                     FY2018Q2           = "d",
                                     FY2018_TARGETS     = "d"))


# Checking the data 
count(na_df, Sex)


# Removing N/A or other undesireable values and convert to 
  # True missing, or blank ""
 
na_df1 <- mutate(na_df, Sex = if_else(Sex == "N/A", "", Sex))  #converts to blanks
count(na_df1, Sex)

# when running models, true <NA> is treated as "missing"
# while blank "" is treated as another category for the variable
# Numeric variables will not accept "", but will have true <NA> only
#-------------------------------------------------------




#-------------------------------------------------------
# ---- (7) Exporting your data (Slide )----- 
# ref: https://www.statmethods.net/input/exportingdata.html
#--------------------------------------------------------


write_tsv(hts4, path = "./Output/exported_data.txt")

write_csv(hts4, path = "./Output/exported_data.csv")


# # exporting to Excel
library(xlsx)
write.xlsx(mcad_df, "./RawData/exp_Excel_data.xlsx")
#-------------------------------------------------------









