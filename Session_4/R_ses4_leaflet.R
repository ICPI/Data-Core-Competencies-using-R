list_of_packages <- c("tidyverse","leaflet","readr","rgdal","sp", 'rgeos', 'RColorBrewer', 'mapview')

#check if packages are installed, if not install missing packages
lapply(list_of_packages, 
       function(x) if(!require(x,character.only = TRUE)) install.packages(x))

library(tidyverse)
library(leaflet)
library(readr)
library(rgdal)
library(sp)
library(rgeos)
library(RColorBrewer)
library(mapview)


df_msd <- read_tsv('ICPI_MER_Structured_TRAINING_Dataset_PSNU_IM_FY17_18_20181012_v1_1.txt')

# read in facilities coordinates
fac_xy <- read_tsv('ICPI_TRAINING_GoT_site_lat_long_20181012.txt')

# read shape files for PSNU & OU
got.psnu <- readOGR(dsn='GoT_PSNUs', layer = 'GoT_PSNUs')
 
got.regions <- readOGR(dsn= 'GoT_Regions', layer= 'GoT_Regions')

 
summary(got.psnu)
summary(got.regions)

#check if the shape files are right ones 
plot(got.psnu)


# Create a map with just lat-long
leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

# Change background map
leaflet() %>% 
  addProviderTiles(providers$CartoDB) %>% 
   addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

leaflet() %>% 
  addProviderTiles(providers$Thunderforest.Landscape) %>% 
   addMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R")

# change the type of marker
m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addCircleMarkers(lng=174.768, lat=-36.852, popup="The birthplace of R", radius = 10)
m


# Let's work with GoT data 

#Plot GoT PSNU shape file with Leaflet
m1 <- leaflet(got.psnu) %>% 
  addTiles() %>%
  addPolygons(color='black', weight=2, opacity=.8, fillOpacity = 0)

# Call the map to display it in the viewer
m1 # Despite adding Tiles in the map, the background is blank
  # This is due to mismatch between CRS projection of GoT shape files and Openstreet Maps

# Check CRS projection of GoT shape files
proj4string(got.psnu)
proj4string(got.regions)
# Set CRS to standard WGS84 
proj4string(got.psnu)<- CRS("+proj=longlat +datum=WGS84 +no_defs")
proj4string(got.regions)<- CRS("+proj=longlat +datum=WGS84 +no_defs")


m1 <- leaflet(got.psnu) %>% 
  addProviderTiles(providers$Thunderforest) %>%
  addPolygons(color='black', weight=2, opacity=.8, fillOpacity = 0)
m1


# Add multiple layers of polygon- PSNU & Regions in the same map
# this useful when you want to display Region and PSNU boundaries distinctly in the same map
m2 <- leaflet() %>% 
  addTiles() %>%
  addPolygons(data=got.psnu, color='black', weight=2, opacity=.8, fillOpacity = 0) %>% 
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0)
m2

# Create Heatmap or Choropleths 
# First, create a color palette

col_pal <- colorFactor(palette = 'Set3', domain = got.psnu@data$PSNU ) # this creates a function that 
# has colors assigned based on PSNU names

#check all the color palettes available in RColorBrewer library
display.brewer.all()

leaflet() %>% 
  addTiles()  %>% 
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu, color='black', weight=2, opacity=.8, 
              fillColor = ~col_pal(PSNU), fillOpacity = 1, label = ~PSNU)


# Create Choropleth based on MSD data
# But the spatial DF doesn't have MSD data in it!
# So, merge MSD data with spatial DF

# Both are PSNU level files, so how do we find which variable to use as key?
# use interset() to see which columns name match between got.psnu@data & df_msd
intersect(names(got.psnu@data), names(df_msd))
got.psnu@data$PSNU <- as.character(got.psnu@data$PSNU)

# aggregate data to PSNU level, so we have just one row per PSNU
# this required to merge MSD with PSNU level shape file
df_msd_agg <- df_msd %>% 
  gather(period, val, FY2018_TARGETS, FY2018Q1, FY2018Q2) %>% 
  mutate(ind_period=paste(indicator, period, sep = '_')) %>% 
  filter(indicator %in% c('TX_CURR', 'TX_NEW')) %>% 
  group_by(OperatingUnit, PSNU, PSNUuid, SNUPrioritization, disaggregate, ind_period) %>% 
  summarise(val=sum(val,na.rm = T)) %>% 
  ungroup() %>% 
  spread(ind_period, val)

got.psnu.msd <- merge(got.psnu, df_msd_agg, by.x='PSNU', by.y='PSNU')

#check if the data was merged
head(got.psnu.msd@data,5)

# Create a choropleth on TX_CURR FY2018Q1 values by PSNU

# first create a color scale based on TX_CURR values; use colorBin 
col_txcurr <- colorBin(palette = 'YlOrRd', domain = got.psnu.msd@data$TX_CURR_FY2018Q2)

leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, label = ~PSNU)

# Now show TX_CURR_FY2018Q2 values in label


leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = ~paste(PSNU, 'TX_CURR:',TX_CURR_FY2018Q2,sep="\n"))

# or Create labels separately, using HTML toots
labels <- sprintf(
  "<strong>%s</strong><br/>TX_CURR: %g </sup>",
  got.psnu.msd@data$PSNU, got.psnu.msd@data$TX_CURR_FY2018Q2
) %>% lapply(htmltools::HTML)

leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = labels)


# Add a Lengend to the map
map_txcurr <- leaflet() %>%  
  addPolygons(data=got.regions, color = 'red', fillOpacity = 0) %>%
  addPolygons(data=got.psnu.msd, color='black', weight=2, opacity=.8, 
              fillColor = ~col_txcurr(TX_CURR_FY2018Q2), fillOpacity = 1, 
              label = labels) %>% 
  addLegend('bottomright', pal = col_txcurr, values = got.psnu.msd@data$TX_CURR_FY2018Q2, title = 'TX_CURR FY2018Q2')

map_txcurr

#### Exercise 1:
# Use TX_NEW FY2018Q2 to create a choropleth


# Add Facility markers in each PSNU
map_txcurr %>% 
  addMarkers(data = fac_xy, lat = ~lat, lng = ~long, popup = ~PSNU) # you can use a non saptial df here, just need to point to lat/long variables in the df

# Change Markers
map_txcurr %>% 
  addCircleMarkers(data = fac_xy, lat = ~lat, lng = ~long, popup = ~sitename, radius = 0.7)

# Display Facilities in the North PSNU
map_txcurr %>% 
  addCircleMarkers(data = fac_xy %>% filter(PSNU=='The North'), lat = ~lat, lng = ~long, popup = ~sitename, radius = 1)

# Exercise 2
# Display facilities in the southern part of the country i.e. latitude < 0

# saving Leaflet Maps
# Leaflet maps can be saved as PDF, JPEG or interactive HTML files
# HTML files are stored as web pages that can be opened in any browser

htmlwidgets::saveWidget(map_txcurr, 'map_txcurr.html') # you can do the same by clicking on Export in the Viewer window

mapshot(map_txcurr, 'map_txcurr.png')

