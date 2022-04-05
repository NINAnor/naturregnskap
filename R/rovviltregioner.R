
library(sf)
library(dplyr)

# We have got a shape file with the eight data regions, but it doens't have any info on the crs.
dat <- sf::st_read("data/supportingData/rovviltregionerUtenCRS/vedtatte forvaltningsregioner 2004.shp")
plot(dat)

# Therefore I just mapped it manually like this.

counties <- sf::st_read("R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_County/versjon_2019/Fylker_2019.shp")
counties$FYLKESNAVN

counties$region <- c("Rovviltregion 1", 
                     "Rovviltregion 8", 
                     "Rovviltregion 8", 
                     "Rovviltregion 6", 
                     "Rovviltregion 1", 
                     "Rovviltregion 2", 
                     "Rovviltregion 2", 
                     "Rovviltregion 4", 
                     "Rovviltregion 2", 
                     "Rovviltregion 4",
                     "Rovviltregion 4", 
                     "Rovviltregion 3", 
                     "Rovviltregion 5", 
                     "Rovviltregion 7", 
                     "Rovviltregion 2",
                     "Rovviltregion 1", 
                     "Rovviltregion 6", 
                     "Rovviltregion 1")
#Combine geometries (union)

rovviltregioner <- counties %>% group_by(region) %>%  summarize()

sf::st_write(rovviltregioner, "data/supportingData/rovviltregioner/rovviltregioner.shp")
