library(raster)

# Importing the DTM tile from Kartverket that overlaps with Nordre Follo
# https://kartkatalog.geonorge.no/metadata/dtm-10-terrengmodell-utm33/dddbb667-1303-4ac5-8640-7ec04c0e3918

# For the extent account we rely on the 10 by 10 meter grid, and for the condition account we use 50 by 50 m

dtm10 <- raster("data/supportingData/DTM10.tif") # Just Norde Follo, not all of Viken!
st_crs(dtm10)

#nf <- readRDS("../../data/outlineNF.rds")

myCounties <- "R:/GeoSpatialData/AdministrativeUnits/Norway_AdministrativeUnits/Converted/Norway_County/Fylke_polygon_2020.shp"
counties <- sf::st_read(myCounties)
viken <- counties[counties$NAVN=="Viken",]




#plot(dtm10)
#plot(viken$geometry, add=T)

# add a 1km buffer
ext <- extent(viken)
ext@xmin <- ext@xmin - 1000
ext@xmax <- ext@xmax + 1000
ext@ymin <- ext@ymin - 1000
ext@ymax <- ext@ymax + 1000


#master10 <- raster::crop(dtm10, ext)

#plot(master10)
#plot(nf$geometry, add=T)

#master10[] <- 99

#writeRaster(master10,'data/supportingData/masterGrid10m.tif', overwrite=T)













t1 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6600_50m_33.tif")
t2 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6701_50m_33.tif")
#t3 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6801_50m_33.tif")
t4 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6501_50m_33.tif")
t5 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6601_50m_33.tif")
t6 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6702_50m_33.tif")
#t7 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6802_50m_33.tif")
t8 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6503_50m_33.tif")
t9 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6700_50m_33.tif")
#t10 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6800_50m_33.tif")
t11 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6502_50m_33.tif")
t12 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6603_50m_33.tif")
t13 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6703_50m_33.tif")
t14 <- rast("R:/GeoSpatialData/Elevation/Norway_DEM_50m_Kartverket/Original/DTM50_UTM33_20210416/6602_50m_33.tif")

plot(viken$geometry)
#plot(t, add=T)
#plot(master50, add=T)
plot(t1, add=T)
plot(t2, add=T)
#plot(t3, add=T)
plot(t4, add=T)
plot(t5, add=T)
plot(t6, add=T)
#plot(t7, add=T)
plot(t8, add=T)
plot(t9, add=T)
#plot(t10, add=T)
plot(t11, add=T)
plot(t12, add=T)
plot(t13, add=T)
plot(t14, add=T)

t <- terra::merge(t1, t2, t4, t5, t6, t8, t9, t11, t12, t13, t14)

plot(t)
plot(viken$geometry, add=T)

#dtm50 <- raster("data/supportingData/DTM50.tif")

master50 <- raster::crop(t, ext)
plot(master50)
plot(viken$geometry, add=T)

master50[] <- 99

writeRaster(master50,'data/supportingData/masterGrid50m.tif', overwrite=T)

