#' @title Modified command "termFreq" on package tm
#'
#' @description Modified command "termFreq" on package tm
#'
#' @param symbol
#'
#' @return NULL
#'
#' @examples
#'
#' @export termFreqCN
termFreqCN<-
  function (doc, control = list())
  {
    stopifnot(inherits(doc, "TextDocument"), is.list(control))
    .tokenize <- control$tokenize
    if (is.null(.tokenize) || identical(.tokenize, "wordsCN"))
      #       .tokenize <- x$content
      .tokenize <- wordsCN
    else if (identical(.tokenize, "MC"))
      .tokenize <- MC_tokenizer
    else if (identical(.tokenize, "scan"))
      .tokenize <- scan_tokenizer
    else if (NLP::is.Span_Tokenizer(.tokenize))
      .tokenize <- NLP::as.Token_Tokenizer(.tokenize)
    if (is.function(.tokenize))
      txt <- .tokenize(doc)
    else stop("invalid tokenizer")
    .tolower <- control$tolower
    if (is.null(.tolower) || isTRUE(.tolower))
      .tolower <- tolower
    if (is.function(.tolower))
      txt <- .tolower(txt)
    .removePunctuation <- control$removePunctuation
    if (isTRUE(.removePunctuation))
      .removePunctuation <- removePunctuation
    else if (is.list(.removePunctuation))
      .removePunctuation <- function(x) do.call(removePunctuation,
                                                c(list(x), control$removePunctuation))
    .removeNumbers <- control$removeNumbers
    if (isTRUE(.removeNumbers))
      .removeNumbers <- removeNumbers
    .stopwords <- control$stopwords
    if (isTRUE(.stopwords))
      .stopwords <- function(x) x[is.na(match(x, stopwords(meta(doc,
                                                                "language"))))]
    else if (is.character(.stopwords))
      .stopwords <- function(x) x[is.na(match(x, control$stopwords))]
    .stemming <- control$stemming
    if (isTRUE(.stemming))
      .stemming <- function(x) stemDocument(x, meta(doc, "language"))
    or <- c("removePunctuation", "removeNumbers", "stopwords",
            "stemming")
    nc <- names(control)
    n <- nc[nc %in% or]
    for (name in sprintf(".%s", c(n, setdiff(or, n)))) {
      g <- get(name)
      if (is.function(g))
        txt <- g(txt)
    }
    if (is.null(txt))
      return(setNames(integer(0), character(0)))
    dictionary <- control$dictionary
    tab <- if (is.null(dictionary))
      table(txt)
    else table(factor(txt, levels = dictionary))
    if (names(tab[1])=="") tab <- tab[-1]
    bl <- control$bounds$local
    if (length(bl) == 2L && is.numeric(bl))
      tab <- tab[(tab >= bl[1]) & (tab <= bl[2])]
    nc <- nchar(names(tab), type = "chars")
    wl <- control$wordLengths
    lb <- if (is.numeric(wl[1])) wl[1] else 3
    ub <- if (is.numeric(wl[2])) wl[2] else Inf
    tab <- tab[(nc >= lb) & (nc <= ub)]
    storage.mode(tab) <- "integer"
    class(tab) <- c("term_frequency", class(tab))
    tab
  }
