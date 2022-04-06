

ecoMapExport <- function(data){
  
  terra::writeRaster(data, "data/supportingData/ecoNordreFollo.tif")
  
}