library(targets)


source("R/functions.R")


# Set target-specific options such as packages.
tar_option_set(packages = c("dplyr",
                            "tmap",
                            "sf",
                            "webshot",
                            "terra",
                            "raster",
                            "stringr"
                            ))


# List of terms

# v_ = variable
# i_ indicator
# ex = export
# fp = forest predators


list(
  
  tar_target(v_fp_file, 
             "data/variables/forestPredators.shp",
             format="file"
             ),
  tar_target(i_fp, 
             rescale(v_fp_file)
              ),
  tar_target(i_fp_process, 
             v_process(i_fp, masterGrid_50, county_file, ecoMap)
              ),
  #tar_target(i_fp_mask,   # merge with process
  #           maskEco(i_fp, ecoMap)
  #),
  tar_target(i_fp_ex,   # merge with rescale?
             i_export(i_fp2019_mask)
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
  tar_target(counties,
             sf::st_read(county_file)
             ),
  tar_target(municipality_file,
             "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_Municipalities/Kommune_polygon_2022_navn.shp",
             format="file"
             ),
  tar_target(municipalites,
             prep_municip(municipality_file)
             ),
  
  
  
  tar_target(masterGrid_50,
             terra::rast(masterGrid_50_file)
             ),
  tar_target(ecoMap,
             crop_and_export(ecoMap_file, counties),
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

