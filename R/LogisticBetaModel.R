#' Logistic Regression Model for Case-Based-Reasoning
#'
#' Regression beta coefficients obtained from a logistic regression model fitted on the 
#' training data are used for building a weighted distance measure between
#' train and test data. Afterwards, we will use these weights for calculating a 
#' (n x m)-distance matrix, where n is the number of observations in the training data, 
#' and m is the number of observations of the test data. The user can use this 
#' distance matrix for further cluster analysis or for extracting for each test observation 
#' k (= 1,...,l) similar cases from the train data. We use the rms-package for model fitting,
#' variable selection, and checking model assumptions.
#' If the user omits the test data, this functions returns a n x n-distance matrix.
#'
#' @section Usage:
#' For usage details see \bold{Methods, Arguments, and Examples} sections.
#' 
#' @section Methods:
#' \describe{
#'   \item{\code{new(formula, ...)}}{This method is used to create an
#'   object of this class \code{LogisticBetaModel}. Formula for analysis has to be 
#'   provided.}
#'   \item{\code{fit(dtData)}}{Fits the CPH model.}
#'   \item{...}{See \link{CBRBase} class.}
#'   }
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @format A \code{\link{R6Class}} generator object
#' 
LogisticBetaModel <- R6Class(classname = "LogisticBetaModel",
                             inherit = RegressionModel,
                             public=list(
                               model       = 'lrm',
                               model_param = list(x = T, y = T)
                             )
)