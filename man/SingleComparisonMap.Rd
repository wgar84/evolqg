% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SingleComparisonMap.R
\name{SingleComparisonMap}
\alias{SingleComparisonMap}
\title{Generic Single Comparison Map functions for creating parallel list methods
Internal functions for making eficient comparisons.}
\usage{
SingleComparisonMap(matrix.list, y.mat, MatrixCompFunc, ..., parallel = FALSE)
}
\arguments{
\item{matrix.list}{list of matrices being compared}

\item{y.mat}{single matrix being compared to list}

\item{MatrixCompFunc}{Function used to compare pair of matrices, must output a vector: comparisons and probabilities}

\item{...}{Aditional arguments to MatrixCompFunc}

\item{parallel}{if TRUE computations are done in parallel. Some foreach backend must be registered, like doParallel or doMC.}
}
\value{
Matrix of comparisons, matrix of probabilities.
}
\description{
Generic Single Comparison Map functions for creating parallel list methods
Internal functions for making eficient comparisons.
}
\author{
Diogo Melo
}
\seealso{
\code{\link{MantelCor}}, \code{\link{KrzCor}},\code{\link{RandomSkewers}}
}

