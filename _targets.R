library(targets)


source("R/functions.R")


# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr",
                            "tmap",
                            "sf",
                            "webshot",
                            "terra",
                            "raster",
                            "fasterize"
                            ))


# List of terms

# v_ = variable
# i_ indicator
# ex = export
# fp = forest predators


list(
  
  tar_target(v_fp_file, 
             "data/variables/forestPredators2019.shp",
             format="file"
             ),
  tar_target(ecoMap_file,
             "data/supportingData/ecoMap_50m.tif",
             format="file"
  ),
  tar_target(masterGrid_50_file,
             "data/supportingData/masterGrid50m.tif",
             format="file"
             ),
  tar_target(county_file,
             "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_County/Fylke_polygon_2020.shp",
             format="file"
             ),
  tar_target(municipality_file,
             "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_Municipalities/Kommune_polygon_2022.shp",
             format="file"
             ),
  
  
  
  tar_target(v_processing, 
             v_process(v_fp_file, masterGrid_50_file, county_file)
             ),
  
  tar_target(i_fp, 
             rescale(v_fp)
             ),
  tar_target(i_fp_mask, 
             maskEco(i_fp, ecoMap)
             ),
  tar_target(i_fp_ex,   # merge with rescale?
             i_export(i_fp2019_mask)
             ),
  
  
  tar_target(masterGrid_50,
             terra::rast(masterGrid_50_file)
             ),
  
  tar_target(ecoMap,
             crop_and_export(ecoMap_file),
             )
  
  
)

#tar_target(v_fp, 
#           sf::st_read(v_fp_file)
#),



#tar_target(workflowFigure, 
#           exportVisnetwork(),
#           cue = tar_cue(mode = "always")
#           )

#targets::tar_cue()
#targets::tar_visnetwork()
#tar_make()

