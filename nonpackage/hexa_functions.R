
# functions for creating hexa mapDK data frame
pick_optimal_n = function(name_2){
  require("raster")
  require("dplyr")
  require("maptools")
  dk.shp_i = subset(dk.shp, NAME_2 == name_2)
  my.df = data.frame()
  for (i in 50:150){
    de_hex_pts = sp::spsample(dk.shp_i, type = "hexagonal", n = i,
                              offset = c(0.5, 0.5), pretty = TRUE) %>%
      sp::HexPoints2SpatialPolygons()
    n.points = length(de_hex_pts) - 100
    my.df.i = data.frame(i = i, n.points)
    my.df = bind_rows(my.df, my.df.i)
  }
  my.df = my.df %>% filter(n.points >= 0) %>%
    filter(n.points == min(n.points)) %>%
    filter(i == min(i))
  return(my.df)
}

create_hexgrid_dk = function(name_2, n)
{
  require("raster")
  require("dplyr")
  require("maptools")
  dk.shp_i = subset(dk.shp, NAME_2 == name_2)

  de_hex_pts <- sp::spsample(dk.shp_i, type = "hexagonal", n = n,
                             offset = c(0.5, 0.5), pretty = TRUE) %>%
    sp::HexPoints2SpatialPolygons()
  de_hex_pts = de_hex_pts[1:100]
  de_hex_pts  = sp::spChFIDs(de_hex_pts, paste(name_2, names(de_hex_pts), sep = "_"))
  return(de_hex_pts)
}
