#' Read FARS data
#'
#' This function reads in FARS data and loads it into a Tidyverse Tibble.
#' You need only specify the \code{filename} argument. It relies on the
#' readr and dplyr packages. It is a function within the \code{fars_map_state}
#' and \code{fars_summarize_years} functions.
#'
#' @param filename A character string giving the filepath to the FARS data
#'
#' @return This function returns a Tidyverse "Tibble" datatable
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df

fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}


#' Create a filename for a FARS data file
#'
#' This function creates a filename in a standardized format for
#' FARS data. It only takes the argument \code{year}.
#'
#' @param year A numeric or integer corresponding with the data's year
#'
#' @return A character string of the filename in the format accident_year.csv.bz2

make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("data/accident_%d.csv.bz2", year)
}

#' Read in FARS file based on year
#'
#' This function searches for and reads in a FARS data file
#' with the specified \code{years} list. It then converts the
#' data into a Tibble with the number of incidents in each month
#' for each specified year. It will notify if the years are invalid.
#' The list of years must be valid. If the files do not exist, the
#' function will create the director, download, and unzip the files.
#'
#' @param years A list of years of data to read in
#'
#' @return A tibble of FARS data with number of events in with each year by month
#'
#' @importFrom dplyr mutate select

fars_read_years <- function(years) {
        if (!file.exists("data")) {dir.create("data")}
        fileUrl <- "https://d3c33hcgiwev3.cloudfront.net/_e1adac2a5f05192dc8780f3944feec13_fars_data.zip?Expires=1590019200&Signature=dQdlUb4gY-BmnTHQPCPtUy-JVAVJRBJBKVA56Rs4RZE4kWLU78kexfqL7a6Po7yYTAmmfec-~BInDLrdheqT0S~ebOIYNVBrBIeivV6zkXMyIfFNzIOIaMa1~IA2~cPX8XZCCzhEWH32dhj8GbeL4G9QJnhhVk5G5qzx8jMr1p0_&Key-Pair-Id=APKAJLTNE6QMUY6HBC5A"
        if (!file.exists("data/fars_data.zip")){download.file(fileUrl, destfile = "data/fars_data.zip")}
        if (!file.exists("data/accident_2013.csv.bz2")) {unzip("data/fars_data.zip")}
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Summarize FARS data observations by year and month
#'
#' This function creates a single Tibble of all FARS data across
#' multiple years. It only takes a list of \code{years}. It is a
#' function within the \code{fars_map_state} and \code{fars_summarize_years}
#' functions. The years must be a valid list.
#'
#' @param years A list of numerical years
#'
#' @return A single Tibble comprised of 1 or more years of FARS data
#'
#' @importFrom dplyr bind_rows group_by summarize
#' @importFrom tidyr spread

fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Create map of state FARS events in a year
#'
#' This function creates a map of a US state with locations
#' of fatal accidents in a given year plotted on it. It requires
#' specification of \code{state.num} and \code{year} variables.
#' The state number must exist and the year must be valid.
#'
#' @param state.num The numerical code corresponding with a U.S. tate
#'
#' @param year The four-digit year of data requested
#'
#' @return A map with accidents plotted by latitutde and longitude
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points

fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
