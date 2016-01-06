#' Plot points on map of Denmark
#'
#' @title Plot points on map of Denmark
#'
#' @name pointDK
#'
#' @author Sebastian Barfort (\email{sebastianbarfort@@gmail.com})
#'
#' @return A ggplot class object
#'
#' @param data A data frame of points
#' @param lon,lat String variables specifying names of longitude and latitude columns in the dataset
#' @param values Does the data set contain values?
#' @param aesthetic Do you want to plot your values using colour and/or size?
#' @param sub A vector of strings specifying subregions to be plotted
#' @param guide.label A string with custom label name
#' @param map.title A string with map title
#'
#' @seealso \url{https://github.com/sebastianbarfort/mapDK}
#' @examples
#'
#' pointDK(benches, sub = "koebenhavn", point.colour = "red")
#' # plot values
#' benches$mydata = 1:nrow(benches)
#' pointDK(benches, values = "mydata", detail = "polling", sub.plot = "koebenhavn", point.colour = "red",
#'        aesthetic = "colour")
#'
#' @export
#'
pointDK <- function(data, lon = "lon", lat = "lat", values = NULL,
                  detail = "municipal", show_missing = TRUE, sub = NULL,
                  aesthetic = "both",
                  sub.plot = NULL,
                  guide.label = NULL, map.title = NULL,
                  map.fill = "gray92", map.colour = "black",
                  point.colour = "black", ...){
  if (detail == "municipal") {
    shapedata = mapDK::municipality
  }
  else if (detail == "parish") {
    shapedata = mapDK::parish
  }
  else if (detail == "municipal.old") {
    shapedata = mapDK::municipality.old
  }
  else if (detail == "zip"){
    shapedata = mapDK::zip
  }
  else if (detail == "rural"){
    shapedata = mapDK::rural
  }
  else if (detail == "region"){
    shapedata = mapDK::region
  }
  else if (detail == "polling"){
    shapedata = mapDK::polling
    # subset if sub.plot is provided
    if (!is.null(sub.plot)){
      shapedata <- subset(shapedata, KommuneNav %in% sub.plot)
    }
  }
  else {
    stop(paste("the detail you provided is not valid"))
  }
  if (missing(data)){
    stop("you have not provided a valid dataset")
  }

  # remove tbl_df from data frame
  if(sum(class(data) == "tbl_df") > 0){
    data = data.frame(data)
  }

  # remove DK characters function
  remove_dk <- function(x){
    x <- gsub("\\u00e6", "ae", x)
    x <- gsub("\\u00f8", "oe", x)
    x <- gsub("\\u00e5", "aa", x)
    return(x)
  }
  # remove non-alphanumeric characters and transform to lowercase
  onlyChar <- function(string) {
    string <- tolower(gsub(" ", "", gsub("[^[:alnum:]]", " ", string)))
    string <- stringi::stri_escape_unicode(string)
    string <- remove_dk(string)
    string <- gsub("\\\\", "", string)
    return(string)
  }

  if (!is.null(values)) {
  my.values = data[, values]
  if(is.numeric(my.values)) {
    discrete <- FALSE
  } else {
    discrete <- TRUE
    values <- as.factor(my.values)
  }
  }

  # select sub ids?
  if (!is.null(sub)) {
    # Match sub and region
    sub_match_all <- match(onlyChar(shapedata$id), onlyChar(sub))
    sub_match_missing <- match(onlyChar(sub), onlyChar(shapedata$id))
    # Remove shapedata not in sub
    shapedata <- shapedata[onlyChar(shapedata$id) %in% onlyChar(sub), ]
    # Remove values not in sub
    values <- values[onlyChar(shapedata$id) %in% onlyChar(sub)]
    # Remove pos not in sub
    pos <- sub_match_all[which(!is.na(sub_match_all))]
    # Check if some region sub is not matched
    if(sum(is.na(sub_match_missing)) > 0) {
      warning(paste("Some sub not recognized:",
                    paste(id[is.na(sub_match_missing)], collapse = ", ")))
    }

  # add values to shapedata
  shapedata[, "values"] <- values[pos]
  }

  # plot
  gp <- ggplot()
  thm <- theme(axis.line=element_blank(),
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
               plot.title = element_text(face='bold'),
               strip.text.x = element_text(size = rel(1), face='bold'),
               strip.background = element_rect(colour="white", fill="white"))
  map <- geom_polygon(data = shapedata,
                      aes_string(x = "long", y = "lat", group = "group"),
                      fill = map.fill,
                      colour = map.colour)
  if (!is.null(values)){
    if(aesthetic == "size"){
      plot.map = gp + thm + map + geom_point(data = data,
                                             aes_string(x = "lon", y = "lat", size = values),
                                             colour = point.colour,
                                             ...)
    }
    else if(aesthetic == "colour"){
      plot.map = gp + thm + map + geom_point(data = data,
                                             aes_string(x = "lon", y = "lat", colour = values),
                                             ...)
    }
    else if(aesthetic == "both"){
      plot.map = gp + thm + map + geom_point(data = data,
                                             aes_string(x = "lon", y = "lat", colour = values,
                                                        size = values),
                                             ...)
    }
  }
  else{
    plot.map = gp + thm + map + geom_point(data = data,
                                           aes_string(x = "lon", y = "lat"),
                                           colour = point.colour, ...)
  }
  plot.map = plot.map + coord_map()
    return(plot.map)
}
