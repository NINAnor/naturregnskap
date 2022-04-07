

# *********************************************
# Crop to extent
# Rasterize is vector data, and reproject if raster data

v_process <- function(myIndicator, myGrid, myCounties){
  
  #if(myIndicator  ) # if it contain shp string
  # indicator <- sf::st_read(myIndicator)
  grid <- terra::rast(myGrid)
  counties <- sf::st_read(myCounties)
  viken <- counties[counties$NAVN=="Viken",]
  
  
  if("sf" %in% class(indicator)) {
   
    indicator_c <- sf::st_crop(indicator, extent(viken))
    terra::rasterize(indicator_c, grid, field=c("v_2010", "v_2019")) 
    
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
crop_and_export <- function(data){
  
  file <- "data/supportingData/ecoMap_50m.tif"
  eco <- terra::rast(file)
  ecoTrans <- terra::project(eco, "EPSG:25833", method = "near") # I think it was OK already, but just in case
  #st_crs(ecoCropped)
  
  nf <- readRDS("data/outlineNF.rds")
  # add a 1km buffer
  ext <- raster::extent(nf)  # find new method using sf
  ext@xmin <- ext@xmin - 1000
  ext@xmax <- ext@xmax + 1000
  ext@ymin <- ext@ymin - 1000
  ext@ymax <- ext@ymax + 1000
  
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
  
  terra::writeRaster(ecoCropped, "data/supportingData/ecoNordreFollo.tif")
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
