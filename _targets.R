library(targets)

# these functions can be merged into one functions.R file later
source("R/functions.R")
source("R/mapPolygons.R")
source("R/exportViz.R")
source("R/rescale.R")
source("R/i_export.R")
source("R/ecosystems.R")
source("R/ecoMapExport.R")



# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr",
                            "tmap",
                            "sf",
                            "webshot",
                            "terra",
                            "raster"
                            ))




list(
  
  tar_target(v_forestPredatorsFile, 
             "data/variables/forestPredators2019.shp",
             format="file"
             ),
  tar_target(v_forestPredators2019, 
             sf::st_read(v_forestPredatorsFile)
             ),
  tar_target(v_map, 
             mapPolygons(v_forestPredators2019)
             ),
  tar_target(rescaled, 
             rescale(v_forestPredators2019)
             ),
  tar_target(i_export, 
             i_export(rescaled)
             ),
  tar_target(ecoMapFile,
             "data/supportingData/ecoMap_50m.tif",
             format="file"
             ),
  tar_target(ecoMapCutandProject,
             ecoMap(ecoMapFile)
             ),
  tar_target(ecoMapExport,
             ecoMapExport(ecoMapCutandProject)
             ),
  tar_target(workflowFigure, 
             exportVisnetwork(),
             cue = tar_cue(mode = "always")
             )
  
)

#targets::tar_cue()
#tar_visnetwork()
#tar_make()

