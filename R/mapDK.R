#' @title Maps of Denmark
#'
#' @name mapDK
#'


mapDK <- function(values = NULL, id = NULL, data,
  detail = "municipal", show_missing = TRUE, sub = NULL,
  guide.label = NULL){

  if (detail == "municipal") {
    shapedata = municipality.new
  }
  else {
    shapedata = parish
  }

  # remove non-alphanumeric characters and transform to lowercase
  onlyChar <- function(string) {
    tolower(gsub(" ", "", gsub("[^[:alnum:]]", " ", string)))
  }

  if (!missing(data)){

    if (is.null(guide.label)){
      guide.label = values
    }

    # make sure both values and id is provided
    if (is.null(values) | is.null(id)){
      stop(paste("You must provide value and id columns as strings"))
    }

    values = data[, values]
    id = data[, id]

    if (!is.null(values) & is.null(id)){
      warning("id not provided. values assigned by order")
    }

    if (!is.null(values) & !is.null(id)){
      if(!is.character(id)){
        stop("id must be a vector of strings otherwise it can be missing and values are assigned by order")
      }

    # id in shapedata
    id.shape <- unique(shapedata$id)

    # transform values to factor
    if(is.numeric(values)) {
      discrete <- FALSE
    } else {
      discrete <- TRUE
      values <- as.factor(values)
    }

    if(is.numeric(id)) {
      id_input <- id
      id <- id.shape[!is.na(match(onlyChar(id.shape), onlyChar(id)))]
    }

    # NA if not all region are provided
    match.all <- match(onlyChar(id.shape), onlyChar(id))
    # NA if some region is not recognized
    match.missing <- match(onlyChar(id), onlyChar(id.shape))

    # do all ids match?
    if(sum(is.na(match.missing)) > 0) {
      warning(paste("Some id not recognized:",
        paste(id[is.na(match.missing)], collapse = ", ")))
    }

    # any regions without data?
    if(sum(is.na(match.all)) > 0) {
      warning(paste("You provided no data for the following ids:",
        paste(id.shape[is.na(match.all)], collapse = ", ")))
    }

    pos <- match(onlyChar(shapedata$id), onlyChar(id))

    # show missing?
    if (show_missing == FALSE) {
      sub_fromData <- id.shape[!is.na(match(onlyChar(id.shape), onlyChar(id)))]
        if (is.null(sub)) {
          sub <- sub_fromData
        }
        else {
          sub <- sub[onlyChar(sub) %in% onlyChar(sub_fromData)]
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
      values <- values[onlyChar(id) %in% onlyChar(sub)]
      # Remove pos not in sub
      pos <- sub_match_all[which(!is.na(sub_match_all))]
      # Check if some region sub is not matched
      if(sum(is.na(sub_match_missing)) > 0) {
        warning(paste("Some sub not recognized:",
          paste(id[is.na(sub_match_missing)], collapse = ", ")))
      }
    }

    # add values to shapedata
    shapedata[, "values"] <- values[pos]
  }
}

else {
  if (!is.null(sub)) {
    # Match sub and region
    sub_match_missing <- match(onlyChar(sub), onlyChar(shapedata$id))
    # Remove shapedata not in sub
    shapedata <- shapedata[onlyChar(shapedata$id) %in% onlyChar(sub), ]
    # Remove values not in sub
    if(sum(is.na(sub_match_missing)) > 0) {
      warning(paste("Some sub not recognized:", paste(sub[is.na(sub_match_missing)], collapse = ", ")))
    }
  }
}

  # plot
  gp <- ggplot(shapedata, aes_string(x = "long", y = "lat", group = "group"))
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
  map <- geom_polygon()
  if (!is.null(values)){
    if(length(unique(sub)) == 1){
      map <- geom_polygon()
    }
    else {
      map <- geom_polygon(aes_string(fill = "values"))
    }

    if (discrete == TRUE) {
      scf <- scale_fill_discrete(name = guide.label)
   }
    else {
      scf <- scale_fill_continuous(name = guide.label)
   }
  return(gp + thm + map + scf)
  }
  else {
    return(gp + map + thm)
  }
}
