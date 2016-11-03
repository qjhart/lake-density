# lake-density
Lake density map for California

This project shows the approximate surface area from lakes for California,
aggregated by county.  The file

[Lakes] data comes from the California Department of Fish and Wildlife data
clearinghouse. [California County] data comes from the State of California,
shapefile from github.  Each dataset is in standard California Projection
[epsg:3310], which is the projection for the estimations.

The data were added to postgis and intersected.  For the summary table, only the
~7000 perennial lakes in the dataset were used.

For example, the five counties with the most perennial surface areas are shown
below. These data are approximate only, actual surface area depends on the
amount of water within the reservoirs at any given time.

The following table shows the 5 counties with the most surface area from lakes.

   name    | count | lake_ha | county_ha | %*10000
---------- | ----- | ------- | --------- | --------
 Imperial  |    28 |   77933 |   1160824 |     671
 Modoc     |   104 |   45132 |   1088488 |     415
 Riverside |    15 |   23801 |   1891067 |     126
 Placer    |   199 |   23343 |    388514 |     601
 Mono      |   626 |   20287 |    810871 |     250

[epsg:3310]: http://spatialreference.org/ref/epsg/3310/
[Lakes]:https://www.wildlife.ca.gov/Data/GIS/Clearinghouse
[National Lakes]:https://catalog.data.gov/dataset/usgs-small-scale-dataset-streams-and-waterbodies-of-the-united-states-200512-shapefile
[California County]: https://github.com/CSTARS/california-counties
