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

#tar_option_set(debug = "ecoMap")

# List of terms

# v_ = variable
# i_ indicator
# ex = export
# fp = forest predators


list(
  
  ## FILES / DELINEATION MAPS ---------------------------------------------
  # These are maps/files that are used inside some of the other targets
  
  
  
  ### MASTER GRID 50 m ------------------------------------------------
  # This is a master raster grid (empty cell values) used to get all the
  # rasters to align perfectly. This version has a 50 x 50 m resolution,
  # which is more than sufficient for the condition account. The extent
  # account uses a 10 x 10 m resolution, but that increases file sizes drastically.
  # The coordinate reference system is EPSG:25833 - ETRS89 / UTM zone 33N and
  # is based on the Elevation model (DEM) from Kartverket. See R/masterGrid.R.
  tar_target(masterGrid_50_file,
             "data/supportingData/masterGrid50m.tif",
             format="file"
  ),
  
  ###  ECOSYSTEMS ---------------------------------------------------------
  # This is the ecosystem delineations map (raster format). It is too coarse 
  # and flawed, and will need to improved in the future
  
  tar_target(ecoMap_file,
             "data/supportingData/ecoMap_50m.tif",
             format="file"
  ),
  ### COUNTY LINES /FYLKESGRENSER --------------------------------------------
  tar_target(county_file,
             "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_County/Fylke_polygon_2020.shp",
             format="file"
  ),
  
  ### MUNICIPALITIES / KOMMUNEGRENSER ------------------------------------------
  tar_target(municipality_file,
             "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_Municipalities/Kommune_polygon_2022_navn.shp",
             format="file"
  ),
  
  
  ## FILES / VARIABLES ----------------------------------
  # The variables are all the the data/ folder as shape files or raster
  # The files contain georeferenced variable estimates for one or several years,
  # and georeferenced reference values (same value for all years).
  # New variables must be added manually into the code below
  # (perhaps these files should be stored on P:/ rather than on gitHub?)
  
  tar_target(v_fp_file, 
             "data/variables/forestPredators.shp",
             format="file"
             ),
  
  
  ## RESCALE THE VARIABLES ---------------------------
  # Currently only set up to handle SF objects.
  # Note that variable estimates need to be in columns named 'v_YYYY',
  # where YYYY is the year, and that reference values need to be in a column 
  # names 'reference'. In the output, the columns with rescaled indicator values
  # are named 'i_YYYY'.
  tar_target(i_fp, 
             rescale(v_fp_file)
              ),
  
  
  
  ## PROCESS THE INDICATORS ----------------------------------------
  # This target takes the indicator and crops it to the extent of the master grid (essentially
  # Viken county). It then rasterizes the data if it is not already, using the master grid as a
  # template. Finally, it masks the raster based on the ecosystem delineation and the chosen 
  # ecosystem type to remove pixels that do not correspond to the ecosystem that this 
  # indicator is designed for.
  
  # Choices for ecosystem type are "forests", "wetlands", "open areas", "urban", 
  # "agriculture", "freshwater" and "marine"
  tar_target(
    i_fp_process, 
      i_process(
        indicator = i_fp,
        ecosystem = "forests", 
        counties, masterGrid_50, ecoMap  # These three should be the same for all targets
        )
      ),
  
  
 
  ## READ FILES --------------------------------------------------
  tar_target(counties,
             sf::st_read(county_file)
             ),
  
  tar_target(municipalites,
             prep_municip(municipality_file, counties, masterGrid_50)
             ),
  
  tar_target(masterGrid_50,
             terra::rast(masterGrid_50_file)
             ),
  
  
  # this target read the ecosystem delineation file and crops it
  # to the extent of Viken county (to reduce file size and handling time)
  tar_target(ecoMap,
      cropEco(
        ecoMap_file, 
        masterGrid_50
              )
             )
  
  
)

# View the pipeline DAG
#targets::tar_visnetwork()

#Alternatively:
#targets::tar_glimpse(targets_only = F)

# BUILD PIPELINE
#targets::tar_make()

# Debugging
#targets::tar_make(callr_function = NULL, names = any_of("ecoMap"), shortcut = TRUE)


# Define criteria for deciding when things are outdated:
#targets::tar_cue()





# An old target used to export the visNetwork figure
#tar_target(workflowFigure, 
#           exportVisnetwork(),
#           cue = tar_cue(mode = "always")
#           )
