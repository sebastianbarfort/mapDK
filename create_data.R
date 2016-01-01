
library("rgdal")
library("rgeos")
library("ggplot2")

create_data = function(link, filename, outputname){
  require("rgdal")
  require("rgeos")
  require("ggplot2")

  dir.create("temp")
  setwd("temp")
  download.file(link,
                destfile="temp.zip")

  unzip("temp.zip")
  map = readOGR(".", filename,
                stringsAsFactors = FALSE)
  map = spTransform(map, CRS("+proj=longlat +datum=WGS84"))
  map = gBuffer(map, width=0, byid=TRUE)
  map = fortify(map, region = "Kommune")
  setwd("../")
  save(map, file = paste0("data/", outputname, ".rda"))
  unlink("temp", recursive = TRUE)
}

create_data(link = "http://www.dst.dk/~/media/Kontorer/16-Formidlingscenter/PC-AXIS/1denmark_municipality_07_dagi-zip.zip",
            filename = "denmark_municipality_07",
            outputname = "municipality")


download.file(link,
              destfile = "test.zip")


