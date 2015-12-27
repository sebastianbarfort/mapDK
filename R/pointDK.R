#' Create quick and beautiful maps of Denmark at different levels of geographic detail
#'
#' @title Maps of Denmark
#'
#' @name mapDK
#'
#' @author Sebastian Barfort (\email{sebastianbarfort@@gmail.com})
#'
#' @return A ggplot class object
#'
#' @param values,id String variables specifying names of value and id columns in the dataset
#' @param data A data frame of values and ids
#' @param detail A string specifying the detail level of the map
#' @param show_missing A logical scalar. Should missing values (including NaN) be showed?
#' @param sub A vector of strings specifying subregions to be plotted
#' @param guide.label A string with custom label name
#' @param map.title A string with map title
#'
#' @seealso \url{https://github.com/sebastianbarfort/mapDK}
#' @examples
#' mapDK(detail = "polling")
#' mapDK(detail = "zip")
#' mapDK(values = "indbrud", id = "kommune", data = crime)
#'
#' @export
#'
pointDK <- function(data, lon = "lon", lat = "lat",
                  detail = "municipal", show_missing = TRUE, sub = NULL,
                  sub.plot = NULL,
                  guide.label = NULL, map.title = NULL){
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

  # select sub ids?
  if (!is.null(sub)) {
    # Match sub and region
    sub_match_all <- match(onlyChar(shapedata$id), onlyChar(sub))
    sub_match_missing <- match(onlyChar(sub), onlyChar(shapedata$id))
    # Remove shapedata not in sub
    shapedata <- shapedata[onlyChar(shapedata$id) %in% onlyChar(sub), ]
    # Remove values not in sub
    values <- values[onlyChar(id) %in% onlyChar(sub)]
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
                      fill = "white",
                      colour = "black")
 plot.map = gp + thm + map + geom_point(data = data, aes_string(x = "lon", y = "lat"))

    return(plot.map)
  }
