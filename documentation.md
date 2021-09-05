# Documentation
## Introduction to ACMT
https://docs.google.com/document/d/18Sii8PldC54C8CERQISAp-jB3ucqhi_GnxlJ7jyaP9U/edit#heading=h.71ad5pdgytfk
## Components
### Geocoder
Converts address to latitude and longitude.  

### Plot area of interest
Creates an area to gather environment measures for. This area will be used for doing area interpolation and incidence aggregation.  

Creating the travelable area requires sending a request to OpenStreetMap so avoid using this when it is importatnt to preserver privacy.  
### Area interpolation
Calculate the estimated values for the specified area and dataset by area interpolation.  

Note that only a small subset of ACS variables will be presented for this demo. Install ACMT to access the full list of ACS variables.  
### Incidence aggregation
Calculate the number of indicences occuring within the specified area for the dataset.  

## Dataset
### Area interpolation
#### American Community Survey (ACS)
The American Community Survey (ACS) is a demographics survey program conducted by the U.S. Census Bureau. The demo uses the 2017 ACS. Install ACMT to select which year of ACS to use. (https://www.census.gov/acs/www/data/data-tables-and-tools/data-profiles/2017/)  
#### Walkability
The Walkability Index dataset characterizes every Census 2019 block group in the U.S. based on its relative walkability. Walkability depends upon characteristics of the built environment that influence the likelihood of walking being used as a mode of travel. (https://edg.epa.gov/metadata/catalog/search/resource/details.page?uuid=%7B251AFDD9-23A7-4068-9B27-A3048A7E6012%7D)  

COUNTHU10: Housing units  
TOTPOP10: Population  
HH: Households (occupied housing units)  
WORKERS: Number of workers in block group (home location)  
AC_TOT: Total geometric area of block group in acres  
AC_WATER: Total water area of block group in acres  
AC_LAND: Total land area of block group in acres  
AC_UNPR: Total land area that is not protected from development (i.e., not a park or conservation area) of block group in acres  
D2A_EPHHM: Employment and household entropy  
D2B_E8MIXA: 8-tier employment entropy (denominator set to the static 8 employment types in the CBG)  
D3b: Street intersection density (weighted, auto-oriented intersections eliminated)  
D4a: Distance from population weighted centroid to nearest transit stop (meters)  
D2A_Ranked: Ranked score of block group's D2a_EPHMM value relative to other block groups  
D2B_Ranked: Ranked score of block group's D2b_E8mixA value relative to other block groups  
D4A_Ranked: Ranked score of block group's D4a value relative to other block groups  
D3B_Ranked: Ranked score of block group's D3b value relative to other block groups  
NatWalkInd: The score represents the relative walkability of a block group compared to other block groups  
Shape_Length: Length of feature in internal units.  
Shape_Area: Area of feature in internal units squared.  

#### NO2
The NO2 land-use regression model estimate data includes national-scale estimates of NO2 in the United States for year 2010. It provides estimates for annual average NO2 concentrations (ppb) using the land-use regression models. (http://spatialmodel.com/concentrations/Bechle_LUR.html#annual)  
#### O3
The ozone concentration (ppb) averaged over year 2017. (https://www.epa.gov/hesc/rsig-related-downloadable-data-files) 

#### PM2.5
The PM2.5 (ug/m3) averaged over year 2017. (https://www.epa.gov/hesc/rsig-related-downloadable-data-files) 

### Incidence aggregation
#### 911 calls
The locations and types of 911 calls from 2015 to 2020. (https://data.seattle.gov/Public-Safety/Seattle-Real-Time-Fire-911-Calls/kzjm-xkqj)  

#### Seattle crime
The locations and types of crimes in Seattle for 2020. (https://data.seattle.gov/Public-Safety/SPD-Crime-Data-2008-Present/tazs-3rd5/data)   

#### Boston crime
The locations and types of crimes in Boston for 2020. (https://data.boston.gov/dataset/crime-incident-reports-august-2015-to-date-source-new-system)  

#### Chicago crime
The locations and types of crimes in Chicago for 2020. (https://www.chicago.gov/city/en/dataset/crime.html)  

#### Los Angeles crime
The locations and types of crimes in Los Angeles for 2020. (https://data.lacity.org/Public-Safety/Crime-Data-from-2010-to-2019/63jg-8b9z)  

#### Airbnb
The locations and types of apartments in the United States gathered in 2020. (https://www.kaggle.com/kritikseth/us-airbnb-open-data)  



