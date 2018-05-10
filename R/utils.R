#' Get the terminal node id of a RandomForest Object
#' 
#' Extracts for each observation and for each tree in the forest the terminal 
#' node id.
#'
#' @param x a data.frame
#' @param rfObject \code{ranger} object
#' 
#' @return Matrix with terminal node IDs for all observations in x (rows) and
#'         trees (columns)
#'         
#' @examples
#' \dontrun{
#' library(ranger)
#' rf <- ranger(Species ~ ., data = iris, num.trees = 5, write.forest = TRUE)
#' terminalNodeIDs(iris[, -5], rf)
#' }
#' 
#' @export
terminalNodeIDs <- function(x, rfObject) {
  testthat::expect_is(rfObject, "ranger")
  testthat::expect_false(object = is.null(rfObject$forest), 
                         info   = "Ranger object does not contain a forest.")
  x <- as.matrix(x)
  res=sapply(1:rf$num.trees, function(tree) {
    cpp_terminalNodeID(x = x, 
                       childNodes1 = rf$forest$child.nodeIDs[[tree]][[1]], 
                       childNodes2 = rf$forest$child.nodeIDs[[tree]][[2]], 
                       splitValues = as.double(rf$forest$split.values[[tree]]),
                       splitVarIds = rf$forest$split.varIDs[[tree]])
  }, simplify = F)
  res <- do.call(cbind, res)
  as.matrix(res)
}


#' @title Transform trees of a \code{ranger}-object to a matrix
#' 
#' @param rfObject \code{ranger} object
#' 
#' @return a \code{matrix} object with 
#' Column 1: tree ID
#' Column 2: node ID
#' Column 3: child node ID 1
#' Column 4: child node ID 2
#'
#' @examples
#' \dontrun{
#' library(ranger)
#' rf.fit <- ranger(Species ~ ., data = iris, num.trees = 5, write.forest = TRUE)
#' forestToMatrix(rf.fit)
#' }
#' 
#' @export
forestToMatrix <- function(rfObject) {
  res <- sapply(1:rfObject$num.trees, function(t) {
    len <- length(rfObject$forest$child.nodeIDs[[t]][[1]])
    data.frame(t   = rep(t, len), 
               n   = seq_len(len),
               id1 = rfObject$forest$child.nodeIDs[[t]][[1]],
               id2 = rfObject$forest$child.nodeIDs[[t]][[2]])
  }, simplify = F)
  res <- do.call(rbind, res)
  as.matrix(res)
}


#' Converts a distance vector into an object of class \code{dist}
#' 
#' @export
asDistObject <- function(x, n, method) {
  structure(.Data  = x,
            Size   = n,
            Labels = 1:n,
            Diag   = F,
            Upper  = F,
            method = method,
            class  = "dist")
}