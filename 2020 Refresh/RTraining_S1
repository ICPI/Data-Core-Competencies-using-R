
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


# R Studio Projects -------------------------------------------------------
# R Studio projects are a great feature which allow you to have one dedicated session for each project you are working on
# One of the great features is that it sets the working directory to the project folder automatically so others can easily
# work off the same file without having to adjust their file paths (and everything is step up the exact same).
# To start an R Project that already exists, double click on the .Rproj file in the folder.
# If you have not opened this session via the .Rproj file, you will need to so that all the file paths work the same on your machine



#### R Training Series: Session 1
#Produced by the DAQ on behalf of ICPI

#Topics covered: 
# 1. Introduction to RStudio and R Packages
# 2. Importing Datasets
# 3. Exploring Datasets
# 4. Interacting with Datasets
# 5. Work Flow Methods in RStudio (not in the script)

#---------------------------------
#Topic 1: Introduction to RStudio and R Packages
#---------------------------------

# Before we get started: "#" allows the user to provide comments within a script that won't affect the commands 
# within. You may notice the color changes to signify this text is not like the other codes within the script.
# They provide an easy way for a programmer to provide context to the code within a script, detail what they 
# want users to know, and provide organizational flow. 

#print list of packages already installed 
installed.packages()

# if you don't already have it, you'll need to
# install tidyverse to run this sessions' script
install.packages("tidyverse")

# load packages
library(tidyverse)

# checking your working directory
getwd() 

# Since we're using an RProj file, the working directory will already be set where we need it to be, but changing
# it is easy and important when calling files using relative paths.  

# example new working directory:
# setwd("C:/Users/[USERID]/[FILEFOLDER]/[FILEFOLDER]")

# .'s can be used to reference, move relative to the set
# hierachy; . = current, .. = a level above 

# setwd (".")
# references the current directory

# setwd("../") 
# goes up one level in the hierarchy

# setwd("../[NEW_FOLDER]") 
# goes up one level in the hierarchy and back into 
# another folder


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 1. Please load the tidyverse package




#---------------------------
#Topic 2: Importing Datasets
#---------------------------

#You can import datasets in two general ways:
# (1) Point-and-click
#     This option requires no explicit coding
#     You can select FILE > IMPORT DATASET > FROM [filtype]
#     Or, click IMPORT DATASET in the Environment pane 

# (2) readr from the tidyverse package

msd <- read_tsv("C:/Users/lqa9/Desktop/DAQ/PVA R training/MER_Structured_TRAINING_Datasets_PSNU_IM_FY18-20_20200214_v1_1.txt",
         col_types = cols(.default = "c",
                          targets	= "d",
                          qtr1	= "d",
                          qtr2	= "d",
                          qtr3	= "d",
                          qtr4	= "d",
                          cumulative = "d"))

# Codes for specifying the type of variable being pulled in
#             "c" = character 
#             "i" = integer 
#             "n" = number 
#             "d" = double (includes decimals)
#             "l" = logical 
#             "D" = date 
#             "T" = date time 
#             "t" = time 
#             "?" = guess


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 2. Import your dataset (.txt file) and name it dataset1
# Feel free to copy and paste from lesson script




#---------------------------
#Topic 3: Exploring Datasets
#---------------------------

# Get to know the structure of the dataset

names(msd) # to see variable names
spec(msd)  # to see variable names and variable types
glimpse(msd) #combines view of names, specs, and the first few rows of data


str(msd) #prints the class, aka structure of the dataset, 
         #variables therein, and provides a quick preview
         #of the data.

# Preview the data

head(msd) #prints the first few rows and columns
View(msd) #opens whole dataset in a new viewing window

# 'distinct' and 'count' show a breakdown of a column's unique values. 
# distinct only displays values whereas count gives you the values and row counts
distinct(msd, operatingunit)
count(msd, operatingunit) 
count(msd, region, operatingunit, snu1, psnu)
View(count(msd, region, operatingunit, snu1, psnu)) 

# option to allow you to easily sort
count(msd, operatingunit, sort = TRUE) 


# by adding in the weight, allows for easy aggregation, similar to pivot table "sum"
# 'n' now reports aggregate value for Qtr1 instead of # of rows.
count(msd, operatingunit, wt = qtr1, sort = TRUE)


# to subset by fiscal year, filter out other years first. Below example shows values foer 2020 only
# NOTE: select() function will be discussed later in script
msd2020 <- filter(msd, fiscal_year == "2020")
count(msd2020, operatingunit, wt = qtr1, sort = TRUE)


# when the desired view is long, use View()
count(msd2020, region, operatingunit, psnu, snu1, wt= qtr1, sort = TRUE)
View(count(msd2020, region, operatingunit, psnu, snu1, wt = qtr1, sort = TRUE))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 3a. View your entire dataset1
# 3b. View the names of all of your variables and PSNUs in your dataset1
# 3c. View the number of unique values in your operatingunit column and in your PSNU columns for dataset1
# 3d. do 3c., but add qtr2 for the "wt" option and sort = TRUE as well  



#---------------------------
#Topic 4: Interacting with Datasets
#---------------------------

#### General syntax for transforming datasets: ####
# new_dataset <- function(old_dataset, options)


#### SORTING ####

# Sorting in ascending order (default)
sorted <- arrange(msd, psnu) #this generates a new df
View(count(sorted, psnu))


# you can specify mutliple variables to sort by just using comma separated lists
sorted2 <- arrange(msd, operatingunit, snu1, psnu, targets) 


#### SUBSETTING ####

#---- Subsetting for Columns (select) -----
geo_df <- select(msd, c(operatingunit, snu1, psnu))

# Unique combinations of row variables 
distinct(geo_df)

# Deleting variables/negative selection
# - or ! can be used to select everything but this var
msd2 <- select(msd, -award_number)
msd2 <- select(msd, !award_number)

# to remove multiple sequential rows use c() and : to
# capture all variables between the two listed
msd2 <- select(msd, -c(pre_rgnlztn_hq_mech_code:award_number))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:


#4a Subset dataset1 to include only the following variables:
# OperatingUnit, PSNU, SNU1, indicator, fiscal_year, qtr2 and name this new dataframe subset1




#---- Subsetting for Rows (filter) -----
# filter for one indicator 
hts <- filter(msd, indicator == "HTS_TST") #uses logical operator Equal To

hts2 <- filter(msd, indicator != "HTS_TST") #uses logical operator Not Equal
View (select(hts2, indicator))
View (count(hts2, indicator)) 


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4b Subset the dataframe named subset1 to include only data for Jupiter and name this new dataframe ou




# filter for multiple indicators
hts3 <- filter(msd, indicator == "HTS_TST" | indicator == "TX_NEW") #uses logical operator OR
View (select (hts3, indicator))
View (count(hts3, indicator)) 


# filter for multiple conditions, (uses logical operator AND) 
hts4 <- filter(msd, indicator == "HTS_TST", cumulative > 100) #uses logical AND
View (select (hts4, indicator, cumulative))
View (count(hts4, indicator, cumulative)) 


# filter for multiple conditions, (uses multiple operators and multiple conditions) 
# Filtering for HTS_TST and TX_NEW total numerator values and its PSNUs
hts5 <- filter(msd, indicator == "HTS_TST" | indicator == "TX_NEW", standardizedDisaggregate == "Total Numerator", cumulative > 100)
View (select (hts5, PSNU, indicator, standardizedDisaggregate, cumulative))
View (count(hts5, PSNU, indicator, standardizedDisaggregate, cunmulative))


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4c Subset the dataframe named ou to include only data for indicators:
# HTS_TST, HTS_TST_POS and standardized disaggregate = Total Numerator. Name this new dataframe "hts"




# ---- Exporting ----- 
#Export dataset (look at help documentation for arguments)
# NOTE: if you did not open this script through an Rprojects file, you will need to input full path location 
write_tsv(hts5, "Output/hts_tx_100.txt")
write_csv(hts5, "Output/hts_tx_100.csv")


# ------- Exercise Question(s) -------------
# Please write and execute your code under the question:

# 4d. Export your dataset, "hts"as a .txt file to a folder called 'output' where your other R training files are. 
# Name it "exported2" in the path step





#---------------------------
#Additional resources
#---------------------------
#overall reference guide: Comprehensive R Archive Network
#https://cran.r-project.org/
#R operators
#https://www.statmethods.net/management/operators.html
#sorting
#https://www.statmethods.net/management/sorting.html
#subsetting
#https://www.statmethods.net/management/subset.html
#subsetting with accessors
#https://www.rdocumentation.org/packages/adegenet/versions/2.0.1/topics/Accessors
#https://rpubs.com/tomhopper/brackets
