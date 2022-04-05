# Rasterize
Here we are rasterizing the vector data to the master raster grid of 50 by 50 meters in EPSG:32833.

Import master grid
```{r}
grid <- raster("../../data/supportingData/masterGrid50m.tif")
```

```{r}
forestPredadors2019r <- fasterize(forestPredadors2019, grid, field="value")
```


```{r}
plot(forestPredadors2019r)
plot(nf$geometry, add=T)
```