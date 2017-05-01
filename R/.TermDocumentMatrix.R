#' @title Useful for TermDocumentMatrix
#'
#' @description Useful for TermDocumentMatrix
#'
#' @param symbol
#'
#' @return NULL
#'
#' @examples
#'
#' @export .TermDocumentMatrix
## Useful for TermDocumentMatrix
.TermDocumentMatrix <-
  function(x, weighting)
  {
    x <- as.simple_triplet_matrix(x)
    if(!is.null(dimnames(x)))
      names(dimnames(x)) <- c("Terms", "Docs")
    class(x) <- c("TermDocumentMatrix", "simple_triplet_matrix")
    ## <NOTE>
    ## Note that if weighting is a weight function, it already needs to
    ## know whether we have a term-document or document-term matrix.
    ##
    ## Ideally we would require weighting to be a WeightFunction object
    ## or a character string of length 2.  But then
    ##   dtm <- DocumentTermMatrix(crude,
    ##                             control = list(weighting =
    ##                                            function(x)
    ##                                            weightTfIdf(x, normalize =
    ##                                                        FALSE),
    ##                                            stopwords = TRUE))
    ## in example("DocumentTermMatrix") fails [because weightTfIdf() is
    ## a weight function and not a weight function generator ...]
    ## Hence, for now, instead of
    ##   if(inherits(weighting, "WeightFunction"))
    ##      x <- weighting(x)
    ## use
    if(is.function(weighting))
      x <- weighting(x)
    ## and hope for the best ...
    ## </NOTE>
    else if(is.character(weighting) && (length(weighting) == 2L))
      attr(x, "weighting") <- weighting
    else
      stop("invalid weighting")
    x
  }
