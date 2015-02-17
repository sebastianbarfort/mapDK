#' Print id column in the \code{mapDK} data
#'
#' @title Print map ID
#'
#' @author Sebastian Barfort (\email{sebastianbarfort@@gmail.com})
#' @name getID
#'
#' @param detail A string specifying the detail level of the map
#'
#' @seealso \url{https://github.com/sebastianbarfort/mapDK}
#' @examples
#' getID()
#' getID(detail = "polling")

getID <- function(detail = "municipal"){
  if (detail == "municipal") {
    shapedata = mapDK::municipality
  }
  else if (detail == "parish") {
    shapedata = mapDK::parish
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
  }
  else {
    stop(paste("the detail you provided is not valid"))
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

  # id in shapedata
  id.shape <- unique(shapedata$id)

  return(onlyChar(id.shape))
}
