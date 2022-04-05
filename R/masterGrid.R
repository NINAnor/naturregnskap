library(raster)

# Importing the DTM tile from Kartverket that overlaps with Nordre Follo
# https://kartkatalog.geonorge.no/metadata/dtm-10-terrengmodell-utm33/dddbb667-1303-4ac5-8640-7ec04c0e3918

# For the extent account we rely on the 10 by 10 meter grid, and for the condition account we use 50 by 50 m

dtm10 <- raster("data/supportingData/DTM10.tif")
st_crs(dtm10)

nf <- readRDS("../../data/outlineNF.rds")

plot(dtm10)
plot(nf$geometry, add=T)

# add a 1km buffer
ext <- extent(nf)
ext@xmin <- ext@xmin - 1000
ext@xmax <- ext@xmax + 1000
ext@ymin <- ext@ymin - 1000
ext@ymax <- ext@ymax + 1000


master10 <- raster::crop(dtm10, ext)

plot(master10)
plot(nf$geometry, add=T)

master10[] <- 99

writeRaster(master10,'data/supportingData/masterGrid10m.tif', overwrite=T)
















dtm50 <- raster("data/supportingData/DTM50.tif")

master50 <- raster::crop(dtm50, ext)

plot(master50)
plot(nf$geometry, add=T)

master50[] <- 99

writeRaster(master50,'data/supportingData/masterGrid50m.tif', overwrite=T)

