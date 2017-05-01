#' @title Modified command "TermDocumentMatrix" on package tm
#'
#' @description Modified command "TermDocumentMatrix" on package tm and defined "TermDocumentMatrixCN"
#'
#' @param symbol
#'
#' @return NULL
#'
#' @examples
#'
#' @export TermDocumentMatrixCN
TermDocumentMatrixCN<-
  function (x, control = list())
  {
    ##  Modified command "TermDocumentMatrix" on package tm
    ##  and defined "TermDocumentMatrixCN"
    stopifnot(is.list(control))
    tflist <- lapply(unname(content(x)), termFreqCN, control)
    tflist <- lapply(tflist, function(y) y[y > 0])
    v <- unlist(tflist)
    i <- names(v)
    allTerms <- sort(unique(as.character(if (is.null(control$dictionary)) i else control$dictionary)))
    i <- match(i, allTerms)
    j <- rep(seq_along(x), sapply(tflist, length))
    docs <- as.character(meta(x, "id", "local"))
    if (length(docs) != length(x)) {
      warning("invalid document identifiers")
      docs <- NULL
    }
    m <- simple_triplet_matrix(i = i, j = j, v = as.numeric(v),
                               nrow = length(allTerms), ncol = length(x), dimnames = list(Terms = allTerms,
                                                                                          Docs = docs))
    bg <- control$bounds$global
    if (length(bg) == 2L && is.numeric(bg)) {
      rs <- row_sums(m > 0)
      m <- m[(rs >= bg[1]) & (rs <= bg[2]), ]
    }
    weighting <- control$weighting
    if (is.null(weighting))
      weighting <- weightTf
    .TermDocumentMatrix(m, weighting)
  }
