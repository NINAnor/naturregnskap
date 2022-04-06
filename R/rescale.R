

rescale <- function(data){
  data_i <- data
  data_i$indicatorValue <- data_i$value/data_i$reference
  data_i <- data_i %>% 
    dplyr::select(-value, -reference)
}

#forestPredators2019 <- sf::st_read("data/variables/forestPredators2019.shp")
