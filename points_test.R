
# points test
library("readr")
df = read_csv("http://wfs-kbhkort.kk.dk/k101/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=k101:baenk_stol_bord&outputFormat=csv&SRSNAME=EPSG:4326")
names(df)

library("dplyr")
library("stringr")
df = df %>%
  select(wkb_geometry)

# cleaning
df$wkb_geometry = gsub("\\(|\\)", "", df$wkb_geometry)
df$wkb_geometry = str_extract(df$wkb_geometry, "[0-9].+")
x = str_split(df$wkb_geometry, pattern  = " ")
x = do.call(rbind.data.frame, x)
df = x
names(df) = c("lon", "lat")
df$lon = as.numeric(as.character(df$lon))
df$lat = as.numeric(as.character(df$lat))

benches = df

save(benches, file = "data/benches.rda")

pointDK(benches, sub = "koebenhavn", point.colour = "red")
pointDK(benches, detail = "polling", sub.plot = "koebenhavn", point.colour = "red")
pointDK(benches, detail = "polling", sub.plot = "koebenhavn", point.colour = "red")


pointDK(benches, sub = "koebenhavn", point.colour = "red")

# plot values
benches$mydata = 1:nrow(benches)
pointDK(benches, values = "mydata", detail = "polling", sub.plot = "koebenhavn", point.colour = "red",
        aesthetic = "colour")


p = ggplot()
p = p + geom_map(map = test, data = test,
                 aes(x=long, y=lat, map_id=id),
                 size = 0.6, fill = "gray90", colour = "black")


ggplot(map, aes_string(x = "long", y = "lat", group = "group")) +
  geom_polygon()
