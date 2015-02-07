library("rgdal")
library("rgeos")
library("plyr")
library("dplyr")
library("ggplot2")

# read map
setwd("~/Downloads/1denmark_municipality_07_dagi-zip")
map = readOGR(".", "denmark_municipality_07",
              stringsAsFactors = FALSE)

map = spTransform(map, CRS("+proj=longlat +datum=WGS84"))

df = data.frame(gCentroid(map, byid = TRUE), id = map$Kommune, nr = map$Kommunenr)

numre = df$nr[df$nr < 200]

for (i in numre){
  df$x[df$nr == i] = df$x[df$nr == i] + 50/i
}

#df$y[df$nr < 200] = df$y[df$nr < 160] + rnorm(18, 0, 1/2)

df.alt = df %>%
  group_by(y) %>%
  mutate(x.alt = x + min(resolution(x), .2)) %>%
  ungroup() %>%
  group_by(x) %>%
  mutate(y.alt = y + min(resolution(y), .1))

ggplot(aes(fill = id), data = df.alt) +
  geom_rect(aes(xmin = x, xmax = x.alt, ymin = y, ymax = y.alt)) +
  theme(axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank(),
        legend.position="none",
        plot.title = element_text(face='bold')) +
  labs(title = "Municipality bins")

ggsave("~/Desktop/bins.png")


df.t = df
df.t$x = round(df.t$x, 1)
df.t$y = round(df.t$y, 1)

library("ggplot2")
gg <- ggplot(df, aes_string(x="y", y="x"))
gg + geom_rect()
gg + geom_tile(aes_string(width = 2, fill="id")) + coord_fixed(ratio=1)
gg <- gg + geom_tile(color=state_border_col, aes_string(fill="fill_color"), size=2, show_guide=FALSE)
gg <- gg + geom_text(color=text_color, size=font_size)
gg <- gg + scale_y_reverse()
gg <- gg + scale_fill_brewer(palette=brewer_pal, name=legend_title)
gg <- gg + coord_equal()
gg <- gg + labs(x=NULL, y=NULL, title=NULL)
gg <- gg + theme_bw()
gg <- gg + theme(legend.position=legend_position)
gg <- gg + theme(panel.border=element_blank())
gg <- gg + theme(panel.grid=element_blank())
gg <- gg + theme(panel.background=element_blank())
gg <- gg + theme(axis.ticks=element_blank())
gg <- gg + theme(axis.text=element_blank())














shapedata = municipality
library(ggplot2)

gg <- ggplot(shapedata, aes_string(x = "long", y = "lat", group = "group"))
gg <- gg + geom_tile(aes_string(fill="group"))
gg <- gg + geom_tile(color=state_border_col, aes_string(fill="fill_color"), size=2, show_guide=FALSE)
gg <- gg + geom_text(color=text_color, size=font_size)
gg <- gg + scale_y_reverse()

state_coords <- structure(list(abbrev = c("AL", "AK", "AZ", "AR", "CA", "CO",
                                          "CT", "DC", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS",
                                          "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE",
                                          "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA",
                                          "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY",
                                          "PR"),
                               state = c("Alabama", "Alaska", "Arizona", "Arkansas",
                                         "California", "Colorado", "Connecticut", "District of Columbia",
                                         "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois",
                                         "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine",
                                         "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi",
                                         "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire",
                                         "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota",
                                         "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
                                         "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah",
                                         "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming",
                                         "Puerto Rico"),
                               col = c(8L, 1L, 3L, 6L, 2L, 4L, 11L, 10L, 11L, 10L,
                                       9L, 1L, 3L, 7L, 7L, 6L, 5L, 7L, 6L, 12L, 10L, 11L, 8L, 6L, 7L,
                                       6L, 4L, 5L, 3L, 12L, 10L, 4L, 10L, 8L, 5L, 8L, 5L, 2L, 9L, 12L,
                                       9L, 5L, 7L, 5L, 3L, 11L, 9L, 2L, 8L, 7L, 4L, 12L),
                               row = c(7L, 7L,
                                       6L, 6L, 5L, 5L, 4L, 6L, 5L, 8L, 7L, 8L, 3L, 3L, 4L, 4L, 6L, 5L,
                                       7L, 1L, 5L, 3L, 3L, 3L, 7L, 5L, 3L, 5L, 4L, 2L, 4L, 6L, 3L, 6L,
                                       3L, 4L, 7L, 4L, 4L, 4L, 6L, 4L, 6L, 8L, 5L, 2L, 5L, 3L, 5L, 2L, 4L, 8L)),
                          .Names = c("abbrev", "state", "col", "row"), class = "data.frame", row.names = c(NA, -52L))

gg <- ggplot(state_coords, aes_string(x="col", y="row"))
gg + geom_tile() + coord_equal() + scale_y_reverse()


df <- read.csv(file.choose())

ggplot(aes(x = Lon, y = Lat, fill = Value), data = df) +
  geom_point() # so the points are there...

ggplot(aes(x = Lon, y = Lat, fill = Value), data = df) +
  geom_tile() # the bad plot you're getting

# make latitude maxes (uniform, so easy)
diff(sort(df$Lat))
df <- transform(df, latmax = Lat + resolution(Lat))

# make latitude maxes (nonuniform, so a little more complicated)
diff(sort(df$Lon))
qplot(diff(sort(Lon)), data = df, geom = 'density')
df <- ddply(df, .(Lat), function(df){
  transform(df, lonmax = Lon + min(resolution(Lon), .2))
})





#+
  # coord_fixed(ratio=1)

# plot
ggplot(aes(fill = Value), data = df) +
  geom_rect(aes(xmin = Lon, xmax = lonmax, ymin = Lat, ymax = latmax)) +
  coord_fixed(ratio=1)

### mapDK

df = municipality
df.t = df %>%
  group_by(id) %>%
  mutate(long.min = long + min(resolution(long), .2),
         long.max = max(long),
         lat.min = long + min(resolution(long), .2),
         lat.max = max(lat))

df.alt = df %>%
  group_by(long) %>%
  mutate(lat.alt = lat + min(resolution(lat), 10000)) %>%
  ungroup() %>%
  group_by(lat) %>%
  mutate(long.alt = long + min(resolution(long), 10000))

ggplot(aes(fill = id), data = df.alt) +
  geom_rect(aes(xmin = long, xmax = long.alt, ymin = lat, ymax = lat.alt))



+
  coord_fixed(ratio=1)




