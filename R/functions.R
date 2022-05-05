
# *********************************************
prep_municip <- function(data, counties, masterGrid_50){
  
  #county_file <- "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_County/Fylke_polygon_2020.shp"
  #counties <- sf::st_read(county_file)
  
  viken <- counties[counties$NAVN=="Viken",]
  
  mun <- st_read(data)
  mun_c <- st_crop(mun, terra::ext(masterGrid_50)) 
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
# mask according to ecoMap

i_process <- function(indicator, ecosystem, counties, masterGrid_50, ecoMap){
  
  # Subset the counties data to only include the geometry for Viken
  viken <- counties[counties$NAVN=="Viken",]
  
  
  # Workflow for SF objects:
  #if(str_detect(indicatorName, "\\.shp")) {
  
  if("sf" %in% class(indicator)) {
    
    # Crop to the extent of Viken county
    indicator_c <- sf::st_crop(indicator, extent(viken))
    
    # the rasterize function cannot take sf objects, so we have to convert to spatVector
    i_c_terra <- terra::vect(indicator_c)
    
    #Get the names of the columns that contain indicator values
    cols <- names(i_c_terra)[str_detect(names(i_c_terra), "i_")]
    
    #Get the corresponding column numbers
    cols_num <- which(names(i_c_terra) %in% cols)
    
    
    # make for-loop to create raster brick with one raster layer per year.
    RS <- rast(masterGrid_50)
    
    for(i in cols){
      print(i)
      out <- terra::rasterize(i_c_terra, masterGrid_50, field=c(i))
      RS <- c(RS, out)
    }
    
    
    # The ecosystem type is writted as text, but needs to be converted into the 
    # correct code used in the ecoMap 
    ecosystemCode <- ecosystem %>%
      dplyr::recode(
        forests = 101,
        wetlands = 501,
        'open areas' = 401,
        urban = 940,
        agriculture = 931,
        freshwater = 601,
        marine = 701)
    
    # Then we can create a mask
    eco <- ecoMap
    eco[eco != ecosystemCode] <- NA
    
    # The grid cells in in the indicator maps that aligne with NA values in eco will be cut out
    out <- terra::mask(RS, eco)
    
    # Export
    # Here we export the indicators as masked rasters.
    # It could be an option to export before rasterizing and masking,
    # but really the normative indicators are not valid outside the 
    # extent of the reference values.
    # Possibly we should export these as single rasters, and not stacks,
    # but we can fix this later.
    terra::writeRaster(
      out, 
      paste0("output/indicators/", deparse(substitute(indicator)), ".tif"),
      overwrite = T)
  
    out

  }
  
}


# *********************************************
rescale <- function(data){
  
  # load file
  data_i <- sf::st_read(data)
  
  
  # Workflow for SF objects:
  # get the column names that start with "v_" (these are the variable estimates)
  cols <- names(data_i)[str_detect(names(data_i), "v_")]
  
  # get the associated column numbers
  cols_num <- which(names(data_i) %in% cols)
  
  #For each column identified above, divide the values with the reference value.
  #The column with reference values is always names 'reference'.
  #The warning is OK. It's just that data_i[,i] also include a 'geometry' column. 
  for(i in cols_num){
    print(i)
    data_i[,i] <- data_i[,i]/data_i[,"reference"]
  }
  
  # from v_ to i_ to say that they have become rescaled
  names(data_i)[str_detect(names(data_i), "v_")] <- 
    str_replace(cols,
                "v_", "i_")
  
  # also remove the column with reference values.
  data_i <- data_i %>% 
    dplyr::select(-reference)
  
  data_i
  
}






# *********************************************
# import and crop the map with ecosystem delineation
cropEco <- function(ecoMap_file, masterGrid_50){
  
  #ecoMap_file <- "data/supportingData/ecoMap_50m.tif"
  
  # load ecosystem delineation map for the entire country
  eco <- terra::rast(ecoMap_file)
  
  # This raster is already projected in EPSG:25833, but it is shifted slightly
  # compared to the master grid, so we will reproject using nearest neighbour
  # in order to get them perfectly aligned
  
  ecoTrans <- terra::project(eco, masterGrid_50, method = "near", align = T) 
  
  
  # Crop the ecosystem delineation map to the extant of Viken in order to decrease its file size
  ecoCropped <- terra::crop(ecoTrans, terra::ext(masterGrid_50))
       #unique(ecoCropped) # ok, Whole values (categorical)
       #barplot(table(ecoCropped[]))
       #plot(ecoCropped)
  
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
       #
  
  terra::writeRaster(ecoCropped, "data/supportingData/ecomap_viken.tif",
                     overwrite = T)
  ecoCropped
  
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
