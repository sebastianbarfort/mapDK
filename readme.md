# mapDK



This is a very incomplete draft of a mapDK package for making easy ggplot2 based maps of Denmark.

Currently, the package allows you to do two things:

1. make basic maps of DK at the municipality or parish level
2. turn these maps into (static) chloropleth maps

I will make it possible to create interactive chloropleth maps when R's interactive libraries such as rCharts, leaftletR, or ggvis, matures a little. 

To install the package simply run


```r
devtools::install_github("sebastianbarfort/mapDK")
```

To use the basic maps simply run 


```r
library(mapDK)
mapDK()
```

![plot of chunk unnamed-chunk-2](figure/unnamed-chunk-2-1.png) 

The default plot is one of Denmark's 98 municipalities. You can plot Denmark at the parish level by adding `detail = "parish"` in the `mapDK` call


```r
mapDK(detail = "parish")
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

To create a static chloropleth map I've added some test data to the package. 

We can create a map by simply specifying the values and id's (as strings) and the dataset in the call to `mapDK`


```r
mapDK(values = "indbrud", id = "kommune", data = test.data)
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-4-1.png) 

If you don't provide names for all municipalities (or parishes), the function will throw a warning. Let's randomly remove 20 rows and plot the data again


```r
test.data.2 = mapDK::test.data[-sample(1:nrow(mapDK::test.data), 20), ]
mapDK(values = "indbrud", id = "kommune", data = test.data.2)
```

![plot of chunk unnamed-chunk-5](figure/unnamed-chunk-5-1.png) 

You can remove missing municipalities by changing `show_missing` to false


```r
mapDK(values = "indbrud", id = "kommune", data = test.data.2, show_missing = FALSE)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6-1.png) 

You can also provide a `sub` option specifying what municipalities in your data you want plotted


```r
mapDK(values = "indbrud", id = "kommune", data = test.data, sub = c("Viborg", "Esbjerg"))
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 




