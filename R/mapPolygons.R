


mapPolygons <- function(data){
  
  
  map <- tm_shape(data)+
    tm_polygons(palette = "RdYlGn")
  
  png("output/test.png")
  map
  dev.off()
  
  
  
}

