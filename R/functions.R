
# *********************************************
prep_municip <- function(data){
  
  #county_file <- "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_County/Fylke_polygon_2020.shp"
  #counties <- sf::st_read(county_file)
  
  viken <- counties[counties$NAVN=="Viken",]
  
  mun <- st_read(data)
  mun_c <- st_crop(mun, extent(viken)) 
  mun_c_vik <- sf::st_intersection(mun_c, viken)
  
  # this results in some municipalities with zero area.
  mun_c_vik$area <- st_area(mun_c_vik)
  #remove those irritating units...
  mun_c_vik$area2 <- as.vector(mun_c_vik$area)
    # according to wikipedia the smalles municipality is Nesodden with ~60 km2
    #setting the limit to b 1 km2
  mun_c_vik <- mun_c_vik[mun_c_vik$area2>1000000,]
  
  mun_c_vik
  
}


# *********************************************
# Crop to extent
# Rasterize if vector data
# Reproject if raster data

v_process <- function(myIndicator, myGrid, myCounties){
  
  #masterGrid_50_file <- "data/supportingData/masterGrid50m.tif"
  grid <- myGrid
  #counties <- sf::st_read(myCounties)
  viken <- counties[counties$NAVN=="Viken",]
  
  #myIndicator <- "data/variables/forestPredators.shp"
  
  if(str_detect(myIndicator, "\\.shp")) {
    
    indicator <- sf::st_read(myIndicator)
    
    indicator_c <- sf::st_crop(indicator, extent(viken))
    
    #rasterize cannot take sf objects, so hvaing to convert to spatVector
    indicator_c_terra <- terra::vect(indicator_c)
    
    out <- terra::rasterize(indicator_c_terra, grid, field=c("v_2010")) 
    #plot(out)
    #plot(viken$geometry, add=T)
    
    out

  }
  
}


# *********************************************
rescale <- function(data){
  data_i <- data
  data_i$indicatorValue <- data_i$value/data_i$reference
  data_i <- data_i %>% 
    dplyr::select(-value, -reference)
}


# *********************************************
i_export <- function(data){
  # ifelse()....
  sf::st_write(data, paste0("output/indicators/", deparse(substitute(data)), ".shp"))
}

# *********************************************
# import and crop the map with ecosystem delineation
crop_and_export <- function(data, counties){
  
  #file <- "data/supportingData/ecoMap_50m.tif"
  
  eco <- terra::rast(ecoMap_file)
  ecoTrans <- terra::project(eco, "EPSG:25833", method = "near") # I think it was OK already, but just in case
  #st_crs(ecoCropped)
  
  viken <- counties[counties$NAVN == "Viken",]
  
  ext <- raster::extent(viken)  # find new method using sf
  
  # add a 1km buffer
  #ext@xmin <- ext@xmin - 1000
  #ext@xmax <- ext@xmax + 1000
  #ext@ymin <- ext@ymin - 1000
  #ext@ymax <- ext@ymax + 1000
  
  # Crop the ecosystem delineation map to the extant of Nordre Follo in order to decrease its file size
  ecoCropped <- terra::crop(ecoTrans, ext)
  # unique(ecoCropped) # ok, Whole values (categorical)
  #barplot(table(ecoCropped[]))
  
  # I don't have the legend, but from looking at the map it is at least clear that
  
  # 101 = forest
  # 931 = Agricultire
  # 940 = Urban
  # 601 = Freshwater
  # 501 = Wetland
  # 401 = something open, close to water
  # 701 = marine
  
  
  #tm_shape(ecoCropped)+
  #  tm_raster(style="cat",
  #            palette = "Accent")
  
  terra::writeRaster(ecoCropped, "data/supportingData/ecomap_viken.tif")
  ecoCropped
  
}




# *********************************************
maskEco <- function(data){
  
  
  
}


##### OLD FUNCTIONS #### 
# *********************************************
#mapPolygons <- function(data){
#  map <- tm_shape(data)+
#    tm_polygons(palette = "RdYlGn")
#  
#  png("output/test.png")
#  map
#  dev.off()
#}



# *********************************************
#exportVisnetwork <- function(data){
#  path <- "figures/targetsWorkflow.html"
#  visNetwork::visSave(tar_visnetwork(),
#                      path)
#  webshot::webshot(path, zoom = 1, file = "figures/targetsWorkflow.png")
#}
