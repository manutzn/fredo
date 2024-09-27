#' Fetch Data from the FRED API
#'
#' Retrieves economic data series from the Federal Reserve Economic Data (FRED) API.
#'
#' @param api_key Your FRED API key as a string.
#' @param series_ids Character vector of FRED series IDs to retrieve.
#' @param start_date Start date in 'YYYY-MM-DD' format.
#' @param end_date End date in 'YYYY-MM-DD' format.
#'
#' @return Data frame containing the combined data.
#'
#' @examples
#' \dontrun{
#' # Replace 'your_api_key_here' with your actual FRED API key
#' api_key <- 'your_api_key_here'
#' series_ids <- c('GNPCA', 'UNRATE')
#' start_date <- '1950-01-01'
#' end_date <- '2024-12-31'
#' data <- fetch_fred_data(api_key, series_ids, start_date, end_date)
#' head(data)
#' }
#'
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
#' @importFrom dplyr select mutate left_join bind_rows
#'
#' @export
fredo <- function(api_key, series_ids, start_date, end_date) {
  # Initialize an empty list to store results
  dataset_list <- list()

  for (i in seq_along(series_ids)) {
    series <- series_ids[i]

    # Construct the query URL for observations
    query_obs <- paste0(
      'https://api.stlouisfed.org/fred/series/observations?',
      'series_id=', series,
      '&api_key=', api_key,
      '&file_type=json',
      '&observation_start=', start_date,
      '&observation_end=', end_date
    )

    # Make the API request for observations
    response_obs <- httr::GET(query_obs)
    output_obs <- httr::content(response_obs, as = "text", encoding = "UTF-8")
    parsed_obs <- jsonlite::fromJSON(output_obs)
    data_obs <- data.frame(parsed_obs$observations)

    # Clean and prepare the observations data
    data_obs <- dplyr::select(data_obs, date, value)
    data_obs <- dplyr::mutate(data_obs,
                              date = as.Date(date),
                              value = as.numeric(value),
                              id = series)

    # Construct the query URL for series information
    query_series <- paste0(
      'https://api.stlouisfed.org/fred/series?',
      'series_id=', series,
      '&api_key=', api_key,
      '&file_type=json'
    )

    # Make the API request for series information
    response_series <- httr::GET(query_series)
    output_series <- httr::content(response_series, as = "text", encoding = "UTF-8")
    parsed_series <- jsonlite::fromJSON(output_series)
    data_series <- data.frame(parsed_series$seriess)

    # Merge the observations and series data
    data_combined <- dplyr::left_join(data_obs, data_series, by = c("id" = "id"))

    # Store the combined data frame in the list
    dataset_list[[i]] <- data_combined

    # Remove variables to free memory
    rm(response_obs, output_obs, parsed_obs, data_obs, query_obs, query_series,
       response_series, output_series, parsed_series, data_series, data_combined)
    gc()
  }

  # Combine all data frames
  dataset <- dplyr::bind_rows(dataset_list)

  return(dataset)
}
