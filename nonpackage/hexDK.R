
load("data/hex_polygons.rda")

# load parking
df = readr::read_csv("http://wfs-kbhkort.kk.dk/k101/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=k101:p_pladser&outputFormat=csv&SRSNAME=EPSG:4326")

library("dplyr")
library("stringr")
df = df %>%
  select(wkb_geometry, antal_pladser)

# cleaning
df$wkb_geometry = gsub("\\(|\\)", "", df$wkb_geometry)
df$wkb_geometry = str_extract(df$wkb_geometry, "[0-9].+")
df$wkb_geometry = gsub("\\,.*","",df$wkb_geometry)
x = str_split(df$wkb_geometry, pattern  = " ")
x = do.call(rbind.data.frame, x)
names(x) = c("lon", "lat")

df = df %>% bind_cols(x) %>% select(-wkb_geometry)

df = df %>%
  mutate(
    lon = as.numeric(as.character(lon)),
    lat = as.numeric(as.character(lat))
  ) %>%
  filter(!is.na(lon)) %>%
  filter(! lon == lat) %>%
  data.frame

test = SpatialPoints(coordinates(df[, c(2,3)]), CRS("+proj=longlat +datum=WGS84"))
proj4string(test)=CRS("+proj=longlat +datum=WGS84")

test = spTransform(test, CRS("+proj=longlat +datum=WGS84")) # move to gen hex file

map_wgs84 <- spTransform(hex_polygons, CRS("+proj=longlat +datum=WGS84")) # move to gen hex file

df$plc <- names(map_wgs84)[over(test, map_wgs84)]

df = df %>%
  group_by(plc) %>%
  summarise(
    pladser = sum(as.numeric(antal_pladser))
  )

hexDK = function(municipality = "København", map.fill = "#fde725"){
  load("data/hex_polygons.rda")
  # filter bases on municipalities
  index = grep(municipality, stringr::str_split_fixed(names(hex_polygons), "_", n = 2)[, 1])
  hex_polygons = hex_polygons[index]

  # turn into data frame
  hex_polygons.df = ggplot2::fortify(hex_polygons)

  # add kommune name
  hex_polygons.df$kommune = stringr::str_split_fixed(hex_polygons.df$id, "_", n = 2)[, 1]

  # basic map
  gg = ggplot()
  gg = gg + geom_map(data = hex_polygons.df, map = hex_polygons.df,
                      aes(x = long, y = lat, map_id = id), size = 0.6,
                      color = "#ffffff", fill = map.fill)
  gg = gg + geom_map(data = df, map = hex_polygons.df,
                      aes(fill = pladser, map_id = plc), color = "#ffffff",
                      size = 0.6)
  gg = gg + scale_fill_viridis(na.value = "gray90", name = "Antal")
  gg = gg + ggthemes::theme_map()
  gg = gg + theme(strip.background = element_blank())
  gg = gg + theme(strip.text = element_blank())
  gg = gg + theme(legend.position = "right")
  gg = gg + coord_map()
  gg = gg + labs(title = "Antal parkeringspladser i København")
 return(gg)
}

# options
municipality = "København"
no_fill = "#fde725"

# filter bases on municipalities
index = grep(municipality, stringr::str_split_fixed(names(hex_polygons), "_", n = 2)[, 1])
hex_polygons = hex_polygons[index]

# turn into data frame
hex_polygons.df = ggplot2::fortify(hex_polygons)

# add kommune name
hex_polygons.df$kommune = stringr::str_split_fixed(hex_polygons.df$id, "_", n = 2)[, 1]

# basic map
gg <- ggplot()
gg <- gg + geom_map(data = hex_polygons.df, map = hex_polygons.df,
                    aes(x = long, y = lat, map_id = id), size = 0.6,
                    color = "#ffffff", fill = no_fill)
gg <- gg + geom_map(data = cur_heat, map = de_hex_map,
                    aes(fill = fill, map_id = id), color = "#ffffff",
                    size = 0.6)
gg <- gg + scale_fill_identity(na.value = no_fill)
gg <- gg + ggthemes::theme_map()
gg <- gg + theme(strip.background = element_blank())
gg <- gg + theme(strip.text = element_blank())
gg <- gg + theme(legend.position = "right")
