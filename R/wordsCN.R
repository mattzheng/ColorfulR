#' @title Modified command "words" on package NLP
#'
#' @description Modified command "words" on package NLP
#'
#' @param symbol
#'
#' @return NULL
#'
#' @examples
#'
#' @export wordsCN
wordsCN<-function(x,...){
  #   words<-unlist(segmentCN(x$content))
  #   return(words)
  return(x$content)
}
