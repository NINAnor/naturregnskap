
#library(terra)
#library(tmaptools)


ecoMap <- function(data){
  
  file <- "data/supportingData/ecoMap_50m.tif"
  eco <- rast(file)
  ecoTrans <- terra::project(eco, "EPSG:25833") # I think it was OK already, but just in case
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
  
  ecoCropped
  
  #tm_shape(ecoCropped)+
  #  tm_raster(style="cat",
  #            palette = "Accent")
  
  
  #barplot(table(ecoCropped[]))
  
  # I don't have the legend, but from looking at the map it is at least clear that
  
  # 101 = forest
  # 931 = Agricultire
  # 940 = Urban
  # 601 = Freshwater
  # 501 = Wetland
  # 401 = something open, close to water
  # 701 = marine
}


