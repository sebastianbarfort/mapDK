
load("data/hex_polygons.rda")

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
