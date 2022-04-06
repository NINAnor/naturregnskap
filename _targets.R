library(targets)


source("R/functions.R")
source("R/mapPolygons.R")
source("R/exportViz.R")


# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr",
                            "tmap",
                            "sf"))




list(
  
  tar_target(forestPredatorsFile, 
             "data/variables/forestPredators2019.shp",
             format="file"
             ),
  tar_target(forestPredators2019, 
             forestPredators2019 <- sf::st_read(forestPredatorsFile)
             ),
  tar_target(map, 
             mapPolygons(forestPredators2019)
             ),
  tar_target(workflowFigure, 
             exportVisnetwork()
  )
)
