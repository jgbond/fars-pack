% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_function.R
\name{fars_read}
\alias{fars_read}
\title{Read FARS data}
\usage{
fars_read(filename)
}
\arguments{
\item{filename}{A character string giving the filepath to the FARS data}
}
\value{
This function returns a Tidyverse "Tibble" datatable
}
\description{
This function reads in FARS data and loads it into a Tidyverse Tibble.
You need only specify the \code{filename} argument. It relies on the
readr and dplyr packages. It is a function within the \code{fars_map_state}
and \code{fars_summarize_years} functions.
}
