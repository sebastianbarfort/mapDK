
source("nonpackage/hexa_functions.R")

### creates hexa data frame -----------------

# dk.shp = raster::getData("GADM", country = "DK", level = 2,
#                          path = tempdir())

# loop to find optimal n
# my.df = data.frame()
# for (k in unique(dk.shp$NAME_2)){
#   my.k = pick_optimal_n(k)
#   my.df = rbind(my.df, my.k)
# }


### creates hexa data frame -----------------

# read optimal n
df.opt.n = readr::read_csv("nonpackage/data/optimal_n.csv")

dk.shp = raster::getData("GADM", country = "DK", level = 2,
                         path = tempdir())

# loop through municipalities
for (k in seq_along(unique(dk.shp$NAME_2))){
  if ( k == 1)
    all.polygons = create_hexgrid_dk(unique(dk.shp$NAME_2)[1], df.opt.n$i[1])
  else{
    polygon.i = create_hexgrid_dk(unique(dk.shp$NAME_2)[k], df.opt.n$i[k])
    all.polygons = maptools::spRbind(all.polygons, polygon.i)
  }
}




