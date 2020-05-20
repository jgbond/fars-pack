
<!-- README.md is generated from README.Rmd. Please edit that file -->

<!-- badges: start -->

<!-- badges: end -->

# FARS

The FARS package provides two functions to make analysis of FARS
datasets easier. One function, fars\_summarize\_years, returns a Tibble
of FARS data showing total events in each month and year. The other,
fars\_map\_state, returns a graphical map of a specified state with
locations of all FARS events in the specified year.

FARS data is from the US National Highway Traffic Safety
Administration’s Fatality Analysis Reporting System, which is a
nationwide census providing the American public yearly data regarding
fatal injuries suffered in motor vehicle traffic crashes. The data
provided in this package only covers the years 2013-2015.

## Accessing the package

``` r
library(devtools)
install_github("jgbond/fars")
library(fars)
```

## Examples

This is an example of how to use the fars\_summarize\_years() function
in action. It takes a list of years as the input. Years generally should
be in 4-digit format. Outputs are not displayed in the vignette.

``` r
fars_summarize_years(list(2013,2014,2015))
```

This is an example of the fars\_map\_state() function in action. As
inputs it takes a numerical code for a U.S. state and a 4-digit year.
Not all states have data for all years. Outputs are not displayed in the
vignette.

``` r
fars_map_state(5, 2014)
```

## Travis badge

[![Build Status](https://travis-ci.com/jgbond/fars-pack.svg?branch=master)](https://travis-ci.com/jgbond/fars-pack)
