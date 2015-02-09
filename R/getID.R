#' @title print map ID
#'
#' @name getID
#'

getID <- function(detail = "municipal"){
  if (detail == "municipal") {
    shapedata = municipality
  }
  else if (detail == "parish") {
    shapedata = parish
  }
  else if (detail == "zip"){
    shapedata = zip
  }
  else if (detail == "rural"){
    shapedata = rural
  }
  else if (detail == "region"){
    shapedata = region
  }
  else if (detail == "polling"){
    shapedata = polling
  }
  else {
    stop(paste("the detail you provided is not valid"))
  }

  # remove DK characters function
  remove_dk <- function(x){
    x <- gsub("æ", "ae", x)
    x <- gsub("ø", "oe", x)
    x <- gsub("å", "aa", x)
    return(x)
  }

  # id in shapedata
  id.shape <- unique(shapedata$id)

  return(remove_dk(id.shape))
}
