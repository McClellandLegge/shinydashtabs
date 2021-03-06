% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/include-r.R
\name{includeR}
\alias{includeR}
\title{Recursively source R scripts and return the values}
\usage{
includeR(path, single_as_list = FALSE, ...)
}
\arguments{
\item{path}{A path to an R script}

\item{single_as_list}{A Boolean. Should a single sourced value be returned
as list? Useful for server functions}

\item{...}{Additional argument to \code{list.files}}
}
\value{
A list if more than one file sourced, otherwise the value itself
}
\description{
Recursively source R scripts and return the values
}
