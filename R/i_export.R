

i_export <- function(data){
  
  
  sf::st_write(data, paste0("output/indicators/", deparse(substitute(data)), ".shp"))
}




