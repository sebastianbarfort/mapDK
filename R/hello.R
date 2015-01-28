#' @export
#' @import ggplot2
#'
#' @title Choropleth Maps of Denmark
#'
#' @name mapDK
# http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Build and Reload: 'Cmd + Shift + B'
#   Check: 'Cmd + Shift + E'
#   Test: 'Cmd + Shift + T'
#
mapDK <- function(values = NULL, id = NULL, dataSource = "data", detail = "municipal", show_missing = TRUE, sub = NULL,
  graphPar = list(
    guide.label = NULL)
  ){

  if (!is.null(values) & is.null(id)){
    warning("id not provided. values assigned by order")
    }

  if (!is.null(values) & !is.null(id)){
    if(!is.character(id)){
      stop("id must be a vector of strings otherwise it can be missing and values are assigned by order")
    }
    ### Remove all non alphanumeric characters from region names and transform to lower case
    onlyChar <- function(string) {
      tolower(gsub(" ", "", gsub("[^[:alnum:]]", " ", string)))
    }

    ### Check if some region name is not matched
    if(sum(is.na(match(onlyChar(id), onlyChar(id.shape)))) > 0) {
      warning(paste("Some id not recognized:", paste(id[is.na(match_missing)], collapse = ", ")))
    }
  }

  ### If dataSource is a dataframe use it
  if (class(data) == "data.frame") shapedata = data
  ### If dataSource is a string load data
  if (class(dataSource) == "character") {
    if (dataSource == "data") {
      if (detail == "municipal") {
        shapedata <- municipality.new # require LazyData in DESCRIPTION
      }
      if (detail == "parish")
        shapedata <- parish
    }
  }

  ### Match region ID or names
  id.shape <- unique(shapedata$id)

  if(is.numeric(id)) {
    id_input <- id
    id <- id.shape[!is.na(match(onlyChar(id.shape), onlyChar(id)))]
  }
  match.all <- match(onlyChar(id.shape), onlyChar(id)) # NA if not all region are provided
  match.missing <- match(onlyChar(id), onlyChar(id.shape)) # NA if some region is not recognized

  pos <- match(onlyChar(shapedata$id), onlyChar(id))


  ### Check if some region name is not matched
  if(sum(is.na(match(onlyChar(id), onlyChar(id.shape)))) > 0) {
    warning(paste("Some id not recognized:", paste(id[is.na(match_missing)], collapse = ", ")))
  }
  ### Select 'sub' regions
  if(show_missing == FALSE) {
    sub_fromData <- id.shape[!is.na(match(onlyChar(id.shape), onlyChar(id)))]
    if(is.null(sub)) {
      sub <- sub_fromData
    } else {
      sub <- sub[onlyChar(sub) %in% onlyChar(sub_fromData)]
    }
  }
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
      warning(paste("Some sub not recognized:", paste(id[is.na(sub_match_missing)], collapse = ", ")))
    }
  }

  ### If the label for the legend is not specified
  if(is.null(graphPar$guide.label)) graphPar$guide.label <- deparse(substitute(values))
  ### If guide.label contains $, keep the second part
  if(grepl("\\$", graphPar$guide.label)) {
    graphPar$guide.label <- unlist(strsplit(graphPar$guide.label, "\\$"))[2]
  }

  ### Transform values to factor
  if(is.numeric(values)) {
    discrete <- FALSE
  } else {
    discrete <- TRUE
    values <- as.factor(values)
  }

  ### Add values to shape data
  shapedata[, "values"] <- values[pos]

  gp <- ggplot(shapedata, aes_string(x = "long", y = "lat", group = "group"))
  map <- geom_polygon()
  if (!is.null(values)){
    map <- geom_polygon(aes_string(fill = "values"))
  }
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
    plot.background=element_blank())

  out <- gp + map + thm
  return(out)
}
