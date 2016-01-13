
fix_letters = function(string){
  string = tolower(string)
  string = gsub("å", "aa", string)
  string = gsub("ø", "oe", string)
  string = gsub("æ", "ae", string)
  string = gsub("-", " ", string)
}

create_data = function(link, filename, region, fix.error = FALSE){
  require("rgdal")
  require("maptools")
  require("rgeos")
  require("ggplot2")

  dir.create("temp")
  setwd("temp")
  download.file(link,
                destfile="temp.zip")

  unzip("temp.zip")
  map = readOGR(".", filename,
                stringsAsFactors = FALSE)
  if(isTRUE(fix.error)){
    proj4string(map) = CRS("+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +no_defs")
  }

  map = spTransform(map, CRS("+proj=longlat +datum=WGS84"))
  map = gBuffer(map, width=0, byid=TRUE)
  map = fortify(map, region = region)

  map[, c(6,7)] = apply(map[, c(6,7)], 2, fix_letters)

  map$group = stringi::stri_escape_unicode(map$group)
  map$id = stringi::stri_escape_unicode(map$id)

  setwd("../")
  unlink("temp", recursive = TRUE)
  return(map)
}

# municipality
municipality = create_data(link = "http://www.dst.dk/~/media/Kontorer/16-Formidlingscenter/PC-AXIS/1denmark_municipality_07_dagi-zip.zip",
            filename = "denmark_municipality_07",
            region = "Kommune")
save(municipality, file = "data/municipality.rda")


# region
region = create_data(link = "http://www.dst.dk/~/media/Kontorer/16-Formidlingscenter/PC-AXIS/Denmark_region_07_dagi.zip",
            filename = "Denmark_region_07",
            region = "Region")
save(region, file = "data/region.rda")

# rural
rural = create_data(link = "http://www.dst.dk/~/media/Kontorer/16-Formidlingscenter/PC-AXIS/Denmark_Rural_07_dagi.zip",
            filename = "Denmark_rural_07",
            fix.error = TRUE,
            region = "NAME")
save(rural, file = "data/rural.rda")

# parish
parish = create_data(link = "http://www.dst.dk/~/media/Kontorer/16-Formidlingscenter/PC-AXIS/Denmark_parish_dagi.zip",
            filename = "Denmark_parish",
            region = "SOGNENAVN")
save(parish, file = "data/parish.rda")

# zip
zip = create_data(link = "http://www.dst.dk/~/media/Kontorer/16-Formidlingscenter/PC-AXIS/Denmark_zip_09_dagi.zip",
            filename = "Denmark_zip_09",
            fix.error = TRUE,
            region = "POSTNR")
save(zip, file = "data/zip.rda")



