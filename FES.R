# Installing and loading required packages

if (!require("tidyverse")) install.packages("tidyverse")
if (!require("tidycensus")) install.packages("tidycensus")
if (!require("sf")) install.packages("sf")
if (!require("mapview")) install.packages("mapview")
if (!require("leaflet")) install.packages("leaflet")
if (!require("leaflet.extras2")) install.packages("leaflet.extras2")

library(tidyverse)
library(tidycensus)
library(sf)
library(mapview)
library(leaflet)
library(leafpop)

options(scipen = 999)

# Transmitting API key

# census_api_key("PasteYourAPIKeyBetweenTheseQuoteMarks")
# census_api_key("494018a70f114d4f76b10537730ccc9c7dbfe36b")

# Specifying target variables

VariableList = 
  c(Estimate_ = "DP05_0037P")

# Fetching the data

mydata <- get_acs(
  geography = "congressional district",
  state = c("TN"),
  variables = VariableList,
  year = 2019,
  survey = "acs1",
  output = "wide",
  geometry = TRUE)

mydata <- rename(mydata, Area = NAME,
                 Estimate = Estimate_E,
                 Range = Estimate_M)

# Mapping the data

Map2019 <- mapview(
  mydata,
  zcol = "Estimate",
  layer.name = "Estimate",
  popup = popupTable(
    mydata,
    feature.id = FALSE,
    row.numbers = FALSE,
    zcol = c("Area", "Estimate", "Range")
  )
)

Map2019

# Plotting the data

mygraph2019 <- ggplot(mydata, aes(x = Estimate, y = reorder(Area, Estimate))) + 
  geom_errorbarh(aes(xmin = Estimate - Range, xmax = Estimate + Range)) + 
  geom_point(size = 3, color = "#099d91") + 
  theme_minimal(base_size = 12.5) +
  labs(title = "Estimates by area", 
       subtitle = "Brackets show error margins.", 
       x = "2019 ACS estimate", 
       y = "")

mygraph2019

###

# Fetching the data

mydata <- get_acs(
  geography = "congressional district",
  state = c("TN"),
  variables = VariableList,
  year = 2023,
  survey = "acs1",
  output = "wide",
  geometry = TRUE)

mydata <- rename(mydata, Area = NAME,
                 Estimate = Estimate_E,
                 Range = Estimate_M)

# Mapping the data

Map2023 <- mapview(
  mydata,
  zcol = "Estimate",
  layer.name = "Estimate",
  popup = popupTable(
    mydata,
    feature.id = FALSE,
    row.numbers = FALSE,
    zcol = c("Area", "Estimate", "Range")
  )
)

Map2023

# Plotting the data

mygraph2023 <- ggplot(mydata, aes(x = Estimate, y = reorder(Area, Estimate))) + 
  geom_errorbarh(aes(xmin = Estimate - Range, xmax = Estimate + Range)) + 
  geom_point(size = 3, color = "#099d91") + 
  theme_minimal(base_size = 12.5) +
  labs(title = "Estimates by area", 
       subtitle = "Brackets show error margins.", 
       x = "2023 ACS estimate", 
       y = "")

mygraph2023

### Graphing Davidson percentages for Harris by precinct diversity

Davidson2024 <- read.csv("https://github.com/drkblake/Data/raw/refs/heads/main/Davidson2024.csv")

ggplot(Davidson2024, aes(x = Pct_Nonwhite,
                         y = Pct_Harris,
                         color = Winner)) +
  geom_point() +
  geom_smooth(method = "lm",
              se = FALSE) +
  labs(x = "Pct. minority",
       y = "Pct. Harris",
       color = "Winner",
       title = "Support for Harris, by percent minority") +
  scale_color_brewer(palette = "Dark2")

Map2023 | PctHarrisMap
